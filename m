Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD858DD61
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245001AbiHIRnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243173AbiHIRno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:43:44 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC99F18
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660067021; bh=/lt1B0+3gQrk+qA1hOIwkyMvMFHUu5Vs4KYKvJUHQl0=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Np7RIKJ8nioFbX5GbfRt3ebD8T3+td1+plR9qt9Zdaywa/bVR0bEn+hLZKn3ZBaxaKe0vHbeQ/5kIZTyWRfxYYSZkZBx7v+LzHHrl9O9HClutGcsypgoVus1GFtU0a+VaAaw/6IDXfiJGukxhsrcihEh/Jxn2iV94f9S38FiwzPC6+hqV/uUhimVPwKnAWXmeyPObk2f8wvq7mn2YxNiIOvKR86YINb6zgflF5kZ6bjJJNJ4+C498sg9EB5v6g78JGwUFBFhDKeLrWQhvGqj0TnFTw3XhR0Lt6TfH+Fw4rydfO+MQ0ST+Oudb2uoati20Nt26n1k9as67AqTtKlbyw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660067021; bh=uONldD82uJIMHRNSZFAd7sXZw7QJJL30/SLvpBnBisf=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=EBo1DMjAJejmgpmdW/ISlEcSmXQkNwkc5UMYj9dKLykL6YBVRKomf27hujfr/NeNzkrzjFd4JFboTwVi+YO74dX8lYdyn7R1e+xqQi8NrzbpSUQM+ImO8lY7Ku7zU4TzFU1OmEvdrBh8YhLa0Rp0zcqP6cLG6vvrgL1n57eQPSF8I4uVQjw4jc/ebgp0i0/oSW+B0YQbhbR0367GMf2vkcEwHnVe5uWF14qlkkWAr4+x4MEnsqbQrwG4QP+VXYjX5dQBm6BIg+ARwYWIUuDgTkYyfpkANGr3Zrngm1yUHD0m9QPh+QHPVUIiYvmruZZe93GXpjknChAH7rlgHhXXsA==
X-YMail-OSG: lUepY3QVM1mIg3ykFRX_VkPtsNFoVtCtjt5uOD3dzMLdddnv9KWKxEVYna37dIj
 MlVgSM5gQr6lXH25dBht6CJawo2Tg71t9s5Pxpe1PwbfYytbWNh3q3Ax6eX7WT2H66_8RzV2kIHH
 atXAS62gp4q2XDJBfVrzDWX8y5x.qDb3iYnPL3SqeDp_RlTryrT7woLpko4yVI5NFZEd2JnGCCNB
 I7M2jmfSrP9sfHJFoit_JWlALPqVFpoWLeR9aPxz1YYN.J7Y0CFmKGQs2E__LYDZ2DQjMwJPp9lc
 QVkAimnUGLt__Idf1dwEHdM9M8y2WhixPTFYI13qSudAahsXVCdrXb5.aJZxBIbbcODhMzPDHqMH
 PqotkRcjH1iCm5f4Je5MAVmciEOTUFrBPQMQ4k8SL0RCQ12yxfNUn.GXpOwuSzCx0bnvGzOt3_KQ
 cQBRCLZQ6RQ5OoyK6TxyBkILjBUfyMO3Q1lNI7r4cS0SM9eCLYrfedKC37riUh_ajb.dCDjleiRk
 LH.AQnImWQOfrh6ENhcnsdo0uZmRoo6CYLVBAF0ljqA4DzNXEnlsidYkbt.dXLJQUSVNwRF7DlQ_
 GvgZW_DG6aPvrMurZdi1i6.8QIRi6XB_DZQozqoQjWRca0x8eCG7uW9avqrIwjK0oWyaKccG2Jwz
 NlOr7OI5_61cYKT6Mn0V9OxLm0kZGYuVQpz_di47GBnL2qNIhI8lgZd5PYp0nRpiYnLkKen4qxeO
 2xREPO0k0JyKaHO8vcs40YhSBnE6BuknHvOKZAqj3w0wuYfQ1RjuBkOD4lgJepDvbwUJrcSJVB6w
 qSRL91H4zhF3a3GQJIojHlz6DJJ9MdiM9aNsvXo8G97EjA1KGCCnmAHPyb5OQ88ii8KQjRaqKP1T
 rO93P4H77GGN_aw2rq5FrjUiAVg_ad63SapQQjyK68Pxj3UVhAhCXSNaQQGVypcK0nae1xnZvUre
 OhIB_A8gWAK.ZuGndmvYlABVgrTMxkfe03N_mihVew72.uekMni4y5U8UVv8ce.SzPuWZOrFYWc1
 GTD7MMj.91.NxViJXTu1qFdRR4VrAMa3k7VCzXxYWjb5TxoFVEiPHfLD9yMatIgRE3ONMEurFu1N
 9oT9RdjrxSUJnfUO5NKRVkMICfn44Q6pe6q1jZ_ngrRlweTP9JA2HUYa0l96o85TZI7WkWx_mXDi
 HPXS2Q8Zyg2pY9x5m4ekts9kZrE4Y0irJeacSnh3iJc6iMML6fUQkAT7tn1L1yuShjcDdf1qbnqW
 bofbnDIcFjqzNBatHWKQc6w4JXY7tjVeZEbYaQfMepskqJRA_eJ_LJPPThLGnRsQ5JPQRTu_YtMZ
 R1MxMjSTbqTc7gGlnNyo4PnnDgUgJkESaMlQ8FCuNJVqRk_7tM.zx2P.2ljR7GcI1rGggCqlNULZ
 .t03NAlb6gx1yOVQFKL4h.l.ybG098cEmfBTQbxLZxpgBAi4c0MmhWju_Ad2Sh6aKBM8_FGkkjKy
 9Tid9pnxjYDTyTE.ZAGSB42nZZSvjwW_SywtYkCp4awlX02VQOdM6WuQDM74TqHm4txipnpgny_e
 ubhl70.9uN_P_xljIzBQksJdb1iiKVfyS_PwXbLEnrzyc7BVJIOjuPuDNHU4F_A3TEJsV_eIt7V6
 OzXVwLz_XQ.v43k6AcHE2KVoZlb.z3pb6g_1ibv.CP2vCoVfpNRTzUYe790EZmsuNAllAmJcrZRM
 N21O6Y4gIn2PnY.CkJQ.dFzoVosQ5sAbs492A2Nrnf4CsMC9BGSGw.FN7DQK76kI40wklGgM.hUk
 2WenM1oeHkBeKre06_ReJ8Z2XuTzV9Zg_hXre0aF83dId1HQpsnwiVQ4AfQ0AbfzdhNuWXoJT_uy
 Ihht0rFxCkW0ZfBYRgtn8jv.4Y5NHz2k6QhRzhQYzmYF9HQgYenChmM4Na1J2KW_1VB5sze8g6Qj
 FSwVPJ3ywpGzNjpdbjpuoNVF0tcwYb5KBJdKaiz2ne1QAheWPDFHNkWnaWwA8PGgXbz4IOHzs0wG
 06hhIuJnhguvfuAE4J7puqmFFuWMH3jorhRh9QElKPe33e4x6Xc5bU6qukKpau2UIBic5YLcCf7U
 T5kUIPnNjJK.1jcfQLuq8ozQMFS4pJnT5gdKmPF.yBwu0z0usOkD03cYuFJRMLfC486yJdS5NqSb
 13l3elNPXafdvKwZhXXzkgh7gsL8dDrsJa1BfoOVncypNVDUo03_aibhjIoFDvygsuOuYAnI0zci
 hzzjbQ4VIfCWlGM0t5CorbJudWwQ3e3.8uDvO.PT0hwI-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Aug 2022 17:43:41 +0000
Received: by hermes--production-bf1-7586675c46-95jxt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID aa23cd124b564927be4f82c5e8078940;
          Tue, 09 Aug 2022 17:43:35 +0000 (UTC)
Message-ID: <f38216d8-8ee4-d6fd-a5b1-0d21013e09c6@schaufler-ca.com>
Date:   Tue, 9 Aug 2022 10:43:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        casey@schaufler-ca.com
References: <20220801180146.1157914-1-fred@cloudflare.com>
 <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
 <877d3ia65v.fsf@email.froward.int.ebiederm.org>
 <87bksu8qs2.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com>
 <87czd95rjc.fsf@email.froward.int.ebiederm.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <87czd95rjc.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20491 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/2022 9:07 AM, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
>
>> On Mon, Aug 8, 2022 at 3:43 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> "Eric W. Biederman" <ebiederm@xmission.com> writes:
>>>> Paul Moore <paul@paul-moore.com> writes:
>>>>
>>>>>> I did provide constructive feedback.  My feedback to his problem
>>>>>> was to address the real problem of bugs in the kernel.
>>>>> We've heard from several people who have use cases which require
>>>>> adding LSM-level access controls and observability to user namespace
>>>>> creation.  This is the problem we are trying to solve here; if you do
>>>>> not like the approach proposed in this patchset please suggest another
>>>>> implementation that allows LSMs visibility into user namespace
>>>>> creation.
>>>> Please stop, ignoring my feedback, not detailing what problem or
>>>> problems you are actually trying to be solved, and threatening to merge
>>>> code into files that I maintain that has the express purpose of breaking
>>>> my users.
>>>>
>>>> You just artificially constrained the problems, so that no other
>>>> solution is acceptable.  On that basis alone I am object to this whole
>>>> approach to steam roll over me and my code.
>>> If you want an example of what kind of harm it can cause to introduce a
>>> failure where no failure was before I invite you to look at what
>>> happened with sendmail when setuid was modified to fail, when changing
>>> the user of a process would cause RLIMIT_NPROC to be exceeded.
>> I think we are all familiar with the sendmail capabilities bug and the
>> others like it, but using that as an excuse to block additional access
>> controls seems very weak.  The Linux Kernel is very different from
>> when the sendmail bug hit (what was that, ~20 years ago?), with
>> advancements in capabilities and other discretionary controls, as well
>> as mandatory access controls which have enabled Linux to be certified
>> through a number of third party security evaluations.
> If you are familiar with scenarios like that then why is there not
> being due diligence performed to ensure that userspace won't break?
>
> Certainly none of the paperwork you are talking about does that kind
> of checking and it most definitely is not happening before the code
> gets merged. 
>
> I am saying that performing that due diligence should be a requirement
> before anyone even thinks about merging a patch that adds permission
> checks where no existed before.
>
> Sometimes changes to fix security bugs can get away with adding new
> restrictions because we know with a very very high degree of probability
> that the only thing that will break will be exploit code.  In the rare
> case when real world applications are broken such changes need to be
> reverted or adapted.  No one has even made the argument that only
> exploit code will be affected.
>
> So I am sorry I am the one who has to be the one to get in the way of a
> broken process with semantic review,  but due diligence has not been
> done.  So I am say no way this code should be merged.
>
>
> In addition to actually breaking existing userspace, I think there is a
> very real danger of breaking userspace, I think there is a very real
> danger of breaking network effects by making such a large change to the
> design of user namespaces.
>
>
>>> I am not arguing that what you are proposing is that bad but unexpected
>>> failures cause real problems, and at a minimum that needs a better
>>> response than: "There is at least one user that wants a failure here".
>> Let me fix that for you: "There are multiple users who want to have
>> better visibility and access control for user namespace creation."
> Visibility sure.  Design a proper hook for that.  All the proposed hook
> can do is print an audit message.  It can't allocate or manage any state
> as there is not the corresponding hook when a user namespace is freed.
> So the proposed hook is not appropriate for increasing visibility.
>
>
> Access control.  Not a chance unless it is carefully designed and
> reviewed.  There is a very large cost to adding access control where
> it has not previously existed.
>
> I talk about that cost as people breaking my users as that is how I see
> it.  I don't see any discussion on why I am wrong.
>
> If we are going to add an access controls I want to see someone point
> out something that is actually semantically a problem.  What motivates
> an access control?

Smack has no interest in using the proposed hook because user namespaces
are neither subjects nor objects. They are collections of DAC and/or
privilege configuration alternatives. Or something like that. From the
viewpoint of a security module that only implements old fashioned MAC
there is no value in constraining user namespaces.

SELinux, on the other hand, seeks to be comprehensive well beyond
controlling accesses between subjects and objects. Asking the question
"should there be a control on this operation?" seems sufficient to justify
adding the control to SELinux policy. This is characteristic of
"Fine Grain" control.

So I'm of two minds on this. I don't need the hook, but I also understand
why SELinux and BPF want it. I don't necessarily agree with their logic,
but it is consistent with existing behavior. Any system that uses either
of those security modules needs to be ready for unexpected denials based
on any potential security concern. Keeping namespaces completely orthogonal
to LSM seems doomed to failure eventually.

>
> So far the only answer I have received is people want to reduce the
> attack surface of the kernel.  I don't possibly see how reducing the
> attack surface by removing user namespaces makes the probability of
> having an exploitable kernel bug, anything approaching zero.
>
> So I look at the calculus.  Chance of actually breaking userspace, or
> preventing people with a legitimate use from using user namespaces > 0%.
> Chance of actually preventing a determined attacker from exploiting the
> kernel < 1%.  Amount of work to maintain, non-zero, and I really don't
> like it.
>
> Lots of work to achieve nothing but breaking some of my users.
>
> So please stop trying to redesign my subsystem and cause me headaches,
> unless you are going to do the due diligence necessary to do so
> responsibly.
>
> Eric
