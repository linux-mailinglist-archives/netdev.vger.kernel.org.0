Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43AD553E78
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352430AbiFUW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiFUW16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:27:58 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4061A2AD1;
        Tue, 21 Jun 2022 15:27:56 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d123so15741793iof.10;
        Tue, 21 Jun 2022 15:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=fNGqJo+i9/6/f3kZZhedEKn3jNfO/JEUEuBNSE2ons8=;
        b=Bsw5bU9aNfX0F844I1T/2Kq4vl6mJFjBGaNV9ZHdP3lfbUJ/NJmLvDw83lq1sZFFOk
         jcxk50T2/0kg5pvZqxPXETFm7ri2eYeXWX6DleBI69HpzlTdwJPOtwNWsJItjFz8O79B
         Z5VES7BJv+nUxwuzojgo6CCgZegw/ZBLHXB9TWjkWI6eWLIzO4nlq4KGdyoaaKMKFCX/
         M69QnFTju+8iE/bwxLJFtsHzxqpssOEXchocaKHpI4dgQ/XeBdJsSco0UzSfmtL1hX3a
         Eg52YGE/4lIAK4fPx8BV4Rz+0CiChofrVsBZPjeItE8yTJg1Uf4s4Vq1nIVl9mpNSrA6
         8WJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=fNGqJo+i9/6/f3kZZhedEKn3jNfO/JEUEuBNSE2ons8=;
        b=gB5ikzvQynttGT3J50uuSZIxutL/gvPNBnEcSW4E3r60DriRnIbXwH9Jfi9i9XOwHZ
         fcpkbMenod7TCAq5eX1l7foQwulqm54ctJkKa/SvZkzs0t8+i1Bigb4oh1S7TaIQM5Fo
         KA+LX9OCtDjkdZ0hd3grgLQjfO+j8tkSYLPg8FC0I9idUTJdeZpYTCmPlY3Er/ffWeD0
         U46ZTbrrPC+NHNECvbKv/4e1puAhhq2m6/vjDM+u5812GSp7mpP85fIg4Qe0duhNPsFG
         GS8lkPZLyRl8937IBWiEGFi35VvIvM2s2yGq3VMSvkVats2Pq26SN+Tj3WTv2L52eSpU
         34RQ==
X-Gm-Message-State: AJIora/AG7MeT4ijtjApez5AV45mOlypKxbPys7c9jbtCFCkYaO8w4g2
        Xmg76OnK5OT1tM+fpISYpAs=
X-Google-Smtp-Source: AGRyM1s7CtUuGPbwQO3uFbWyjsf6za/ECqC0G+2mNEFJEQFJ6RUGx/b3UQVkQauF8xeSlfZOHgzUag==
X-Received: by 2002:a05:6638:1301:b0:331:f2f0:a17e with SMTP id r1-20020a056638130100b00331f2f0a17emr227630jad.141.1655850475088;
        Tue, 21 Jun 2022 15:27:55 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id h18-20020a02c732000000b0032e3b0933c6sm7637267jao.162.2022.06.21.15.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:27:54 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:27:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org,
        john.fastabend@gmail.com, songliubraving@fb.com, kafai@fb.com,
        yhs@fb.com
Cc:     dhowells@redhat.com, keyrings@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        kernel test robot <lkp@intel.com>
Message-ID: <62b245e22effa_1627420871@john.notmuch>
In-Reply-To: <20220621163757.760304-4-roberto.sassu@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-4-roberto.sassu@huawei.com>
Subject: RE: [PATCH v5 3/5] bpf: Add bpf_verify_pkcs7_signature() helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roberto Sassu wrote:
> Add the bpf_verify_pkcs7_signature() helper, to give eBPF security modules
> the ability to check the validity of a signature against supplied data, by
> using user-provided or system-provided keys as trust anchor.
> 
> The new helper makes it possible to enforce mandatory policies, as eBPF
> programs might be allowed to make security decisions only based on data
> sources the system administrator approves.
> 
> The caller should provide both the data to be verified and the signature as
> eBPF dynamic pointers (to minimize the number of parameters).
> 
> The caller should also provide a keyring pointer obtained with
> bpf_lookup_user_key() or, alternatively, a keyring ID with values defined
> in verification.h. While the first choice gives users more flexibility, the
> second offers better security guarantees, as the keyring selection will not
> depend on possibly untrusted user space but on the kernel itself.
> 
> Defined keyring IDs are: 0 for the primary keyring (immutable keyring of
> system keys); 1 for both the primary and secondary keyring (where keys can
> be added only if they are vouched for by existing keys in those keyrings);
> 2 for the platform keyring (primarily used by the integrity subsystem to
> verify a kexec'ed kerned image and, possibly, the initramfs signature).
> 
> Note: since the keyring ID assignment is understood only by
> verify_pkcs7_signature(), it must be passed directly to the corresponding
> helper, rather than to a separate new helper returning a struct key pointer
> with the keyring ID as a pointer value. If such pointer is passed to any
> other helper which does not check its validity, an illegal memory access
> could occur.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reported-by: kernel test robot <lkp@intel.com> (cast warning)
> ---
>  include/uapi/linux/bpf.h       | 17 +++++++++++++++
>  kernel/bpf/bpf_lsm.c           | 39 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 17 +++++++++++++++
>  3 files changed, 73 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7bbcf2cd105d..524bed4d7170 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5339,6 +5339,22 @@ union bpf_attr {
>   *		bpf_lookup_user_key() helper.
>   *	Return
>   *		0
> + *
> + * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *trusted_keys, unsigned long keyring_id)
> + *	Description
> + *		Verify the PKCS#7 signature *sig* against the supplied *data*
> + *		with keys in *trusted_keys* or in a keyring with ID
> + *		*keyring_id*.

Would be nice to give precedence here so that its obvious order between
trusted_keys and keyring_id. 

> + *
> + *		*keyring_id* can have the following values defined in
> + *		verification.h: 0 for the primary keyring (immutable keyring of
> + *		system keys); 1 for both the primary and secondary keyring
> + *		(where keys can be added only if they are vouched for by
> + *		existing keys in those keyrings); 2 for the platform keyring
> + *		(primarily used by the integrity subsystem to verify a kexec'ed
> + *		kerned image and, possibly, the initramfs signature).
> + *	Return
> + *		0 on success, a negative value on error.
>   */
