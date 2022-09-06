Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856435AEFDB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbiIFQGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbiIFQFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:05:47 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC54BA8
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:29:10 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 65so1489022pfx.0
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 08:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=22GHhBGxs8jlO5k0UplRrIY5gUtV1yOb+CWAaqqW1FU=;
        b=XssJOCkbFij8L2G8wvzLLG/aFQDQtp2HkuJrpb4D8t2tBxE46DJ61wufVOsG0pws6U
         nJpMxxkeJHGkb+ebfs/gazrRpq28/8kvjpfMNGCZItQIaZUwlxXhAY2iRA/asB/EMjzh
         0UqvckfVuOK3tB5QlTpE2+VqbEbNIPAvqGCRHnp2DUFSHpBAw0cK7SjPxLJjnrAePgKE
         YxYvlM2iX8FPTXRx6uEX374WhfAEfB3eeoICuaQckC0y0TnCJghUxUKD+96+rHg0QzXA
         AdceQKJyhvMkBFZ6X1CGRHmMFRHaVKVWOeawlozwYtjHGQDbtedjE4E6rw6t7tLfD6Va
         80mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=22GHhBGxs8jlO5k0UplRrIY5gUtV1yOb+CWAaqqW1FU=;
        b=yuH8GOHmxtddgMZRiU7Jg6vU9xBYt+RyV83dbGEgtnmj+p8QwjTIKH+l0+99gVWSnX
         cYtR9A29gs3gq3mRevDORXRj8CY3zP6rxpu3RG0mx7Y8KSUFBeqKxbN+PTnPoyvXlhty
         do4RBsGEC6IFfH3dEmCLzswiIVAPL3heam8cqG85FGpd94JJvZhLvDgOR6Rdv8sv3MA+
         TDSeW+nFYjWU0/NUF03/Y0q7NvWpY00vSsgUAq+pvzzRgolLkEiTP3iyHM56QMR94Kp5
         hK9R3hddXYKwrfUjl3x/Aa70ZmJF3vYG/zOrLz/Wy8wd3gNbth1VSFeMQ9ZKDcaFkbZL
         FNEQ==
X-Gm-Message-State: ACgBeo3rXuei8wPoLovT+HNPncN7m1x/Z37cTnIqJz2Iw80kyfo0uK3v
        tbl5BGQkGkwopFI3JGPiExPoQ6T8gAnuOA==
X-Google-Smtp-Source: AA6agR6oHSXOXpCGsF85DFc25y1TLbS2+S+ALAOI2T/Pz10UCKEvfYng9/qauHXB9RwtB3UaVNoZhg==
X-Received: by 2002:a05:6a00:4393:b0:52f:3603:e62f with SMTP id bt19-20020a056a00439300b0052f3603e62fmr55466906pfb.23.1662478149894;
        Tue, 06 Sep 2022 08:29:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 135-20020a62188d000000b0053dd1bc5ac6sm4214119pfy.66.2022.09.06.08.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 08:29:09 -0700 (PDT)
Date:   Tue, 6 Sep 2022 08:29:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change
 DSA master
Message-ID: <20220906082907.5c1f8398@hermes.local>
In-Reply-To: <20220904190025.813574-1-vladimir.oltean@nxp.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
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

On Sun,  4 Sep 2022 22:00:25 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Support the "dsa" kind of rtnl_link_ops exported by the kernel, and
> export reads/writes to IFLA_DSA_MASTER.
> 
> Examples:
> 
> $ ip link set swp0 type dsa master eth1
> 
> $ ip -d link show dev swp0
>     (...)
>     dsa master eth0
> 
> $ ip -d -j link show swp0
> [
> 	{
> 		"link": "eth1",
> 		"linkinfo": {
> 			"info_kind": "dsa",
> 			"info_data": {
> 				"master": "eth1"
> 			}
> 		},
> 	}
> ]
> 
> Note that by construction and as shown in the example, the IFLA_LINK
> reported by a DSA user port is identical to what is reported through
> IFLA_DSA_MASTER. However IFLA_LINK is not writable, and overloading its
> meaning to make it writable would clash with other users of IFLA_LINK
> (vlan etc) for which writing this property does not make sense.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Using the term master is an unfortunate choice.
Although it is common practice in Linux it is not part of any
current standard and goes against the Linux Foundation non-inclusive
naming policy.
