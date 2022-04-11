Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5684FC15C
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243474AbiDKPsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348566AbiDKPr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:47:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBC81408C
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:45:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso5030759pjf.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qtxEK4iDNtbmK2XNkMf7q8CK5Ka1Xqoz+gnq/ttFMmo=;
        b=7430tGx3Xxwb/etR5oAPifS4GT5X7PfbsUciSk6NSTK53ZliSHUKI+FGHA33wXHgLT
         uxoJguy2FB7hzPTvNXHzqnDRFl3npiVHEhdqtFNdhTKXhazddH/lMd74vnuWgmWxkXzo
         rdvI1qF1TJ6HP7maMi+88FZEJlW4NTcy9yfrvZ6Ab+xmYAcM+l+ZqcyN3Vbe3/XX3bb3
         qwUOU+gXd5udvPqYaYYFA0uKJWOI3UmS6JtSaVnYDTffO6YrDwt7o/jaJ1FtkK4XybM9
         qGZ1nWCTmwYhiquOMnI4cOhi8QG03FNx9/qhgF28UOtH/mL+x4vdtjOx5LJCA+tC7w8J
         hJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qtxEK4iDNtbmK2XNkMf7q8CK5Ka1Xqoz+gnq/ttFMmo=;
        b=rWq4oMnsvYl8IRqe8UhaBLT4Z5ea1gRi0iCR4L0agnf1EzLaEQqqg8tjPMXKNOJTxr
         zI5TmnncjWjHQVRu0aDOP52fR/NOdWIKA1HPcInSZkrd3FqS1MSIOUt4PhLSVDpf4UmL
         cpee2kRqUotHL2hcdk4IPb6MrgXm/Ckay4Bgwt1YS7iiFFc/NUJ0ssQaKGRzibw8HuSX
         +fUwXazqjlLYaaoGIcG48Y16a05xnlLBqov2y7xp5pxVzwYp8cIKsMTSR9Zqo7zawFwx
         wDy0Ma2Pf0cQoaPBGMPspUv/6sXQTGBe+KLmkoDjYiwA/sUoh1yAUcegiWCEzDhTKlip
         llYA==
X-Gm-Message-State: AOAM5337Dud6xN1GkiPpueJLbfOHC9ij9syfgp6pyvhtKgMNWPlWUMSJ
        aHAVS2qE/dXiYuS08Ol05Bgt/w==
X-Google-Smtp-Source: ABdhPJwGhH3XaBadoJ71DmqhffR3Cl8uD0gMpfjjKaim9FMzTBtXcQmmpVZoNdG88MVKw4TlPin0Bg==
X-Received: by 2002:a17:902:e94e:b0:154:3a4:c5e8 with SMTP id b14-20020a170902e94e00b0015403a4c5e8mr33291129pll.19.1649691939285;
        Mon, 11 Apr 2022 08:45:39 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id mw10-20020a17090b4d0a00b001c7cc82daabsm22739177pjb.1.2022.04.11.08.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:45:38 -0700 (PDT)
Date:   Mon, 11 Apr 2022 08:45:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH iproute2-next 0/2] flower: match on the number of vlan
 tags
Message-ID: <20220411084536.1f18d4ea@hermes.local>
In-Reply-To: <20220411133202.18278-1-boris.sukholitko@broadcom.com>
References: <20220411133202.18278-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 16:32:00 +0300
Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:

> Hi,
> 
> Our customers in the fiber telecom world have network configurations
> where they would like to control their traffic according to the number
> of tags appearing in the packet.
> 
> For example, TR247 GPON conformance test suite specification mostly
> talks about untagged, single, double tagged packets and gives lax
> guidelines on the vlan protocol vs. number of vlan tags.
> 
> This is different from the common IT networks where 802.1Q and 802.1ad
> protocols are usually describe single and double tagged packet. GPON
> configurations that we work with have arbitrary mix the above protocols
> and number of vlan tags in the packet.
> 
> The following patch series implement number of vlans flower filter. They
> add num_of_vlans flower filter as an alternative to vlan ethtype protocol
> matching. The end result is that the following command becomes possible:
> 
> tc filter add dev eth1 ingress flower \
>   num_of_vlans 1 vlan_prio 5 action drop
> 
> The corresponding kernel patches are being sent separately.
> 
> Thanks,
> Boris.

Maybe something custom like this is better done by small BPF program?
