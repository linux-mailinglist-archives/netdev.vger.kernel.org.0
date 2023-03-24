Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777126C7520
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 02:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCXBii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 21:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXBih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 21:38:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A193A40C0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 18:38:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so3670001pjb.4
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 18:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679621916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Rv0v53sXf7/FLG91XQVFtkaMPsPq882H+XOMNLAVfs=;
        b=JDPDtMn0uNPivhJuxuihdF44n3CojtdPbzPY6l+p2U+NbfmU93TsgEE7y6H3LJdXnI
         4PAuhRdCkteujYpO70xAULkv5nqMWiOyaxMdMK8Og1TG6+1NQhO61ynU8LXSlR8+BmTg
         +MhjIw7FOT+Q2WV8GAfY0Q00NnR729h0NHyKrOy6r+tIMz7Tv+VpbxiFVuXVEJ42VRa+
         7XWInvTfG6F+VWoZZuzbchK855dOm3YQ+wHzakAq9/H8x4GT1qjXenij5qDc2q8/dvtZ
         R1BGxpMvh9VJ1HIIZhUPbVJSWeucVBIq4f32GaTsB+Za7dGMMfIxWXO5K3DinovUK74+
         FHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679621916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Rv0v53sXf7/FLG91XQVFtkaMPsPq882H+XOMNLAVfs=;
        b=4Pik1OpidXykEaRrDK3ydHn1TeTzDA2mt8DfoW36Vl+thMwWJGegcksOjgQzW35GQ3
         PzceiYfad6FxKWuIQ/RCVF1nBTiwRJnDBVDPVxpzVZ4iPB12C7B4q/Tu5tPNDXHPU2f9
         mfgtcUAUE5pwCgb84ue0PqkQ5B/ThPfx/8KeAk2OlP5JtwLmomPXBJOlzu5u/6D0cmJQ
         m+9TMs2l8NPcWNRSunbEYtleKe4zpjDcWXjmGiLOjWIkxj/AAS4KYsuP0ULzgqZfGpOg
         YZB/6NEdkt3ap6vLUtDjJjifFOP8VLaVmgWPRm+TfAwyMbvQQ99LRBxRtJnEfjXFYo1z
         PVVw==
X-Gm-Message-State: AAQBX9eMgRq8GNt7oAerdC1RB53zdBY5ZoQVNw2VfQZzFJnOota07OPd
        onc1dpk+cCMCdKgu+i59+XM=
X-Google-Smtp-Source: AKy350bzsOPo3y94sOmpicdlgVd6tNAXgSpGFn8nyi4mgps+Q6F+Jsvi8UnpBcGbczeHf+15kkZO4A==
X-Received: by 2002:a17:90b:4a47:b0:23b:4bf6:bbee with SMTP id lb7-20020a17090b4a4700b0023b4bf6bbeemr1026190pjb.21.1679621915873;
        Thu, 23 Mar 2023 18:38:35 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090a598800b0022335f1dae2sm1874949pji.22.2023.03.23.18.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 18:38:34 -0700 (PDT)
Date:   Fri, 24 Mar 2023 09:38:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, idosch@nvidia.com, eyal.birger@gmail.com,
        jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v1 1/1 v1] ip-link: add support for
 nolocalbypass in vxlan
Message-ID: <ZBz/FREYO5iho+eO@Laptop-X1>
References: <20230323060451.24280-1-vladimir@nikishkin.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323060451.24280-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

For the subject prefix, [PATCH iproute2-next] is enough for the v1 patch.

On Thu, Mar 23, 2023 at 02:04:51PM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the nolocalbypass vxlan netlink
> attribute. With nolocalbypass, if an entry is pointing to the
> local machine, but the system driver is not listening on this
> port, the driver will not drop packets, but will forward them
> to the userspace network stack instead.
> 
> This commit has a corresponding patch in the net-next list.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
>  include/uapi/linux/if_link.h |  1 +
>  ip/iplink_vxlan.c            | 18 ++++++++++++++++++
>  man/man8/ip-link.8.in        |  8 ++++++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index d61bd32d..fd390b40 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -824,6 +824,7 @@ enum {
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
>  	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
> +	IFLA_VXLAN_LOCALBYPASS,
>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)

There is no need to include the uapi header. Stephen will sync it with upstream.

Hi Stephen, should we add this note to the README.devel?

> diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
> index c7e0e1c4..17fa5cf7 100644
> --- a/ip/iplink_vxlan.c
> +++ b/ip/iplink_vxlan.c
> @@ -276,6 +276,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  		} else if (!matches(*argv, "noudpcsum")) {
>  			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
>  			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
> +		} else if (!matches(*argv, "localbypass")) {
> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
> +		} else if (!matches(*argv, "nolocalbypass")) {
> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);

matches is deparated, please use strcmp instead.

Thanks
Hangbin
