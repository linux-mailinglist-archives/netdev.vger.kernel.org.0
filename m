Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CF354D721
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 03:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356686AbiFPBg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 21:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347985AbiFPBgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 21:36:55 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5284057984
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 18:36:54 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n11so124732iod.4
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 18:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLUGXrqOHQOsir08lP6RK8a7Hv7qyvb4djg5zmUdCCs=;
        b=LNaKhOwqACvpCUAog5NX8Ap/mrL/8Sq5E1ZfZ5G/IlQb0VfeFVkUYfpRNc+cqTkAqy
         TCeHfIrtuA92pTN3n9m/FbfyDrsGjAid45yIVkVYqzGmH0to9ZHh1+OI9QBkNzL7qqBf
         DZMu2ESsmlfKLQMO2+Jn7EfM7PlT51s7lyzp6KnWKJBMd3skxdcpAw000BlU7a6l0PqY
         7RPxWweNrU1Q89z9jb64yjTDcoxbRlGEstk66pWCm3KyR6Xn1U4/r1vvApTVihiRcO+B
         w5xevQDWlVVz3aQWGoKf1C8hQD25f14Y9IyFL2DnHW8prabihwzdC1p/Kb7uu2+uZk93
         6bMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KLUGXrqOHQOsir08lP6RK8a7Hv7qyvb4djg5zmUdCCs=;
        b=C27LjBhMLgg5aCAmNSW21r0gzxdNVb/oyvbWDiSHrMUgn9XHmHLse612VTu117yZDw
         Djes2ZHaVgQjrHUdli+w67zlpzfrXMzImU+Pevq5/OdQNrMxKMgvS94G5E+Gw8Z+q/+x
         RvFL2DR0lipIqpOUI14INsxcHJwOVme17j2fznNYvpnPMR76vbqxwPkUd+vYILnTx+zj
         unY1rUJLsHnR7oKM6+N1R18cFDNYX2sHOEpWn0+/So2YpfpcxGZMzu4a19KN48J3GaUn
         8iMpUekcxTU1xQi3meUsPUy0HC+rkMGzcE79m+rSBm4zWcCkAPrwb+lWD17vd1ZqBfyY
         SeTA==
X-Gm-Message-State: AJIora/SlnabPrMFRc2UfHLilUKxud9jZu8OsE9l3rTHlJXM1Iw9Pjay
        LVWdIhVKlO3s6EE9wHBXo1kWr+hLx+LRMhK5sqljCw==
X-Google-Smtp-Source: AGRyM1vWBZ7vS4WyQRP87GheRqZX8lPBh3G80o2TCvAEzi4Ve0Po42zYbOxyWJng4ye7URYp5aw4jbfTKrBTwcb7fnQ=
X-Received: by 2002:a05:6638:d86:b0:331:fb54:c3e3 with SMTP id
 l6-20020a0566380d8600b00331fb54c3e3mr1430903jaj.198.1655343413501; Wed, 15
 Jun 2022 18:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com>
 <YqodE5lxUCt6ojIw@google.com> <YqpAYcvM9DakTjWL@google.com>
 <YqpB+7pDwyOk20Cp@google.com> <YqpDcD6vkZZfWH4L@google.com>
In-Reply-To: <YqpDcD6vkZZfWH4L@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 15 Jun 2022 18:36:42 -0700
Message-ID: <CANP3RGcBCeMeCfpY3__4X_OHx6PB6bXtRjwLdYi-LRiegicVXQ@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I've bisected the original issue to:
> > >
> > > b44123b4a3dc ("bpf: Add cgroup helpers bpf_{get,set}_retval to get/set
> > > syscall return value")
> > >
> > > And I believe it's these two lines from the original patch:
> > >
> > >  #define BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(array, ctx, func)            \
> > >     ({                                              \
> > > @@ -1398,10 +1398,12 @@ out:
> > >             u32 _ret;                               \
> > >             _ret = BPF_PROG_RUN_ARRAY_CG_FLAGS(array, ctx, func, 0, &_flags); \
> > >             _cn = _flags & BPF_RET_SET_CN;          \
> > > +           if (_ret && !IS_ERR_VALUE((long)_ret))  \
> > > +                   _ret = -EFAULT;
> > >
> > > _ret is u32 and ret gets -1 (ffffffff). IS_ERR_VALUE((long)ffffffff)
> > returns
> > > false in this case because it doesn't sign-expand the argument and
> > internally
> > > does ffff_ffff >= ffff_ffff_ffff_f001 comparison.
> > >
> > > I'll try to see what I've changed in my unrelated patch to fix it. But
> > I think
> > > we should audit all these IS_ERR_VALUE((long)_ret) regardless; they
> > don't
> > > seem to work the way we want them to...
>
> > Ok, and my patch fixes it because I'm replacing 'u32 _ret' with 'int ret'.
>
> > So, basically, with u32 _ret we have to do IS_ERR_VALUE((long)(int)_ret).
>
> > Sigh..
>
> And to follow up on that, the other two places we have are fine:
>
> IS_ERR_VALUE((long)run_ctx.retval))
>
> run_ctx.retval is an int.

I'm guessing this means the regression only affects 64-bit archs,
where long = void* is 8 bytes > u32 of 4 bytes, but not 32-bit ones,
where long = u32 = 4 bytes

Unfortunately my dev machine's 32-bit build capability has somehow
regressed again and I can't check this.
