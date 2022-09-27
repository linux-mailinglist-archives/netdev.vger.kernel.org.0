Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EC95EC984
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiI0QbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiI0Qau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A75FDD5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664296181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/22ImDqWPcx+BCBCH7KE7jknxMYidPPfPEsVvaKfI8o=;
        b=OuVSaHnH8T73ABbi1HvBGz2Z10W8hw0AdvCq3TLDkm0qJbYVSis5GokQZT9Zh6/bO7inIF
        Ylfoua0LsFJhXw29OYY3BwUM+BUQIUlAalLBjJZrSJEXSwuSbCgLW7OmmdgouQK9qfF38U
        gmc+NRK8kniY5JQIlXsBADtgnD3obEA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-424-75HLvWsuNbm5nEsCYuCExA-1; Tue, 27 Sep 2022 12:29:40 -0400
X-MC-Unique: 75HLvWsuNbm5nEsCYuCExA-1
Received: by mail-wm1-f71.google.com with SMTP id p9-20020a05600c23c900b003b48dc0cef1so2963822wmb.1
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=/22ImDqWPcx+BCBCH7KE7jknxMYidPPfPEsVvaKfI8o=;
        b=a//pGIHeJhXaZdPXTdhO+sD3YbdoQeNkIOTolIOuDr00z6Bafliie1r2DazseyGOf2
         HPcAXyiMIVQf16OEa06F/VbLZzAlPWFm0ezsaKAS3JkY2uzNYk5hstAenOw3UAzi/mpa
         m7neZC7v5VzaKZMxK5R7lOf1Jitw3qJiw5m3OEW31nBTfgpm3PpPG9kbkpxfxVyAkDP3
         BXp5cvrkAsh9LzrwrU23gvoyarWtPR4SqNYWZO0sHzq40KixNQyqQbJrAqcc85MyQ4JR
         LFuvc1gGsXnSvIdkcFxg2zQdpa5rIAP7RDwmwz5QZfYMi6hlMf9agTcJ7qW6eFQHewe9
         XYCQ==
X-Gm-Message-State: ACrzQf34QQV9nJOxm8TMB8lgQzM0Ti0hBg9sjmxqnNmKtMNC1t77Eht8
        Qx1DkjTmI3enMxUP1Iu58jPOCxbIWaJ5eOV3jdtxU8hijxnTqhsEBlsb7IT6/ueQYatGzbYPbtj
        GIpR0RDnRifAgs3m5
X-Received: by 2002:a05:6000:2c8:b0:22a:efdf:ecc0 with SMTP id o8-20020a05600002c800b0022aefdfecc0mr18071500wry.57.1664296179290;
        Tue, 27 Sep 2022 09:29:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5pf4rYL2VmURVl6S9la4ROhGb4F89GU3IvATpRfCbjawd8HB4wO6UGOr7n9fMt0JCp8sHCkw==
X-Received: by 2002:a05:6000:2c8:b0:22a:efdf:ecc0 with SMTP id o8-20020a05600002c800b0022aefdfecc0mr18071493wry.57.1664296179048;
        Tue, 27 Sep 2022 09:29:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id fc17-20020a05600c525100b003b435c41103sm17220937wmb.0.2022.09.27.09.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:29:38 -0700 (PDT)
Message-ID: <089fbf5cac70b07f059ea095eaaddc30532cdb03.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: sched: fix the err path of
 tcf_ct_init in act_ct
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
Date:   Tue, 27 Sep 2022 18:29:37 +0200
In-Reply-To: <CADvbK_dyOapTEOzOrAJM9GXAG8quR+ZeV6QYY0p2KrA6Z-Hk_g@mail.gmail.com>
References: <cover.1663946157.git.lucien.xin@gmail.com>
         <208333ca564baf0994d3af3c454dc16127c9ad09.1663946157.git.lucien.xin@gmail.com>
         <5a7a07d34b68b36410aa42f22fb4c08c5ec6a08c.camel@redhat.com>
         <CADvbK_dyOapTEOzOrAJM9GXAG8quR+ZeV6QYY0p2KrA6Z-Hk_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-09-27 at 10:45 -0400, Xin Long wrote:
> On Tue, Sep 27, 2022 at 8:43 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Fri, 2022-09-23 at 11:28 -0400, Xin Long wrote:
> > > When it returns err from tcf_ct_flow_table_get(), the param tmpl should
> > > have been freed in the cleanup. Otherwise a memory leak will occur.
> > > 
> > > While fixing this problem, this patch also makes the err path simple by
> > > calling tcf_ct_params_free(), so that it won't cause problems when more
> > > members are added into param and need freeing on the err path.
> > > 
> > > Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > 
> > I think it's better if you re-submit this patch for -net explicitly, as
> > it LGTM and makes sense to let it reach the affected kernel soon.
> If so, I will have to wait until this patch is merged on net-next,
> then post the other one for net-next, right?

Yes. Note that such merge happens once per week...

Cheers,

Paolo

