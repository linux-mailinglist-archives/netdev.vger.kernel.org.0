Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C09358CCFD
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 19:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiHHRrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 13:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244557AbiHHRqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 13:46:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ACC18391;
        Mon,  8 Aug 2022 10:45:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a8so9445435pjg.5;
        Mon, 08 Aug 2022 10:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=56amwkxBxRXvr+sAaZ6aOdlYxwoLvxM3ykitrGAaah8=;
        b=a1ORMxvWpNX0kXnwXKBq7GyVGHtyasCj9mr5eiGioDbfg8bzRhhMa4+Yve6CnlCLMz
         D18k1F3uMoGcb+kA0JV2I35sQPNPSe7IjqaBcI5pF6JvnRvdoTLZoaYLM4uBUv8OcFh1
         LgblEaYB12PZxWbrOlUM6w1EGR5JErkVMA/++h6oi0a/hpFYxZkswB8zHRsyaCZ42wb2
         B5d4fe59pfkX8ZC7WmjsfEmJBZa+SFnoZky6yf2WZowWYZsUCNEO1yHNRBP12XsNV1px
         pcItye+E8CDXhwXh4rHlkqPXAGVdM2QHfTl+xZfO7NTNSEPTodUspE8UuJ/+PRmrrfKW
         MAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=56amwkxBxRXvr+sAaZ6aOdlYxwoLvxM3ykitrGAaah8=;
        b=FhXxk50rcgKf0oQNQlo9FElXFZp/4XMQvrR3eJFA9nkyP20Fj1kF/2YtGQa4GHwNXb
         oKEOtzD6hG2XbF9aVvTfhL7g8rBYtL/2CMXAO2SD8lJZMzZm9AAO1yq2LkLeKUxsOrUi
         Z8jM1j+EFhLVal62AOPvyIMkmu8V9NAq7r57wCBRqa8uF2m+BcoDZHs6xQqfCVO8BrQG
         aczVL8h1C3CHa+fu/WhIgwgP3sCdbeKuoyEajQOKKkhB710oB06Aa+Kldc+jnJoqyz3C
         RGMRqQT/+iAi/UbzPLzEDekxfaix/InkIAjApa/CacyujI9iO3uYJ1CHLvxxeTqQDLh3
         engA==
X-Gm-Message-State: ACgBeo0WvPUbGPUmVMtHd3ofsvIojcu4ILmkR+2sZv1119JeiEEhqh6L
        olVEj4jiuwI0CZFxMD1wDw==
X-Google-Smtp-Source: AA6agR6LbEQBelXM0gcZPBphI3mlLlv/Oto+0IcXSWAxuNg1pWhe08gw7+wvsUwO7qJ/n+m5wwdHig==
X-Received: by 2002:a17:902:da92:b0:16e:f2ee:b98a with SMTP id j18-20020a170902da9200b0016ef2eeb98amr19723760plx.154.1659980740077;
        Mon, 08 Aug 2022 10:45:40 -0700 (PDT)
Received: from bytedance ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090a67c100b001f30f823145sm10945804pjm.55.2022.08.08.10.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 10:45:39 -0700 (PDT)
Date:   Mon, 8 Aug 2022 10:45:36 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        George Zhang <georgezhang@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>,
        Andy King <acking@vmware.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] vsock: Fix memory leak in vsock_connect()
Message-ID: <20220808174536.GA19626@bytedance>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
 <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
 <20220808075533.p7pczlnixb2phrun@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808075533.p7pczlnixb2phrun@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 09:55:33AM +0200, Stefano Garzarella wrote:
> On Sun, Aug 07, 2022 at 02:00:11AM -0700, Peilin Ye wrote:
> > net/vmw_vsock/af_vsock.c | 8 +++++++-
> > 1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index f04abf662ec6..fe14f6cbca22 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -1391,7 +1391,13 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> > 			 * timeout fires.
> > 			 */
> > 			sock_hold(sk);
> > -			schedule_delayed_work(&vsk->connect_work, timeout);
> > +
> > +			/* If the timeout function is already scheduled,
> > +			 * reschedule it, then ungrab the socket refcount to
> > +			 * keep it balanced.
> > +			 */
> > +			if (mod_delayed_work(system_wq, &vsk->connect_work, timeout))
>                             ^
> Checkpatch warns here about line lenght.
> If you have to re-send, please split it.

Oh, net-next HEAD's checkpatch --strict didn't complain, I didn't know
Patchwork checks 80 columns.  I will send v3 soon.

> Anyway, the patch LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks!

Peilin Ye

