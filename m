Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1056A51CC83
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386604AbiEEXLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiEEXLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:11:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9C45F8D6
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:07:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso5373642pjb.5
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 16:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g5cXeDu8DaghjPyC6aqZDOVhdWA9bOEPzkJFDyXbVYw=;
        b=JM3HrM5mf1MXDMk9qZA/27eaRt9EI5cKo5gvQL5cSQFvKvwL3ecWfxPXPA6PMNcuTE
         kvAqQzZYroc5BLuMF2afiztB0WB6V245fYsj4B6JvVVaIy+DZ+1L8qK4iHdV70r9bXKH
         ZZ5tpL9HIu+WhFizvAbBowsWOSMuxF2Y7pFq6WesK7sFDUHkCdq6bbCQklJNUPzbITv9
         vmsg68E9cjLT/IWlONpnfKsc0tB6AxSSlkbLTiMFYWdjx5Hkz/Z5HzLLMA4446W6C9yq
         Omrggo1CZCOwm7zk1mNGF7mtJ4iQD2z5akqFope1k1slyFyjZKDxZD/F2LL3HiSG3IIW
         0vLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g5cXeDu8DaghjPyC6aqZDOVhdWA9bOEPzkJFDyXbVYw=;
        b=wEhhkN1tUAfNkH9d7hkmqxAbWmr5peHO1zJfpMYlX/x8zUaaFId4lxSSKHltHJISOI
         nwzawiYDQ7U7G8C8aICua0OrRCoxqomPYSJ60siAV1dK0gdtgNwNUEATpTm4BOcLn41r
         0j/R+XESTfCLBryS89zZ69gJqZ7wlO7Ys55w/jFa9ByLexWo64Dotbp9oWh9+RlUaswO
         7MKl5TmWjmX+Mdu8rSfJf2URQ/YUIm1MrczL3RfUXCFJE76DoITL5slbKrDbCSFRQv1j
         E6aOC0LQzrPBtMK0F4ARQjNB4x+vlzJopPwDgBE2LjIYW2cLCWqMMqx4WBS/71yPND5o
         XBAw==
X-Gm-Message-State: AOAM533I22+OA95kjSzTWcSRPoY4T9xBdUgW+jjgQjD+RZRKVg5PDCFW
        ho+B+LbdGdLmd4EJ+kpxDNtDwVLDEouKXQ==
X-Google-Smtp-Source: ABdhPJx9r4dHBOtUb/Fnn0rmhE/3d2ws8/xrrGp1U+WrjPjXh/RE5A9D32opdQOwkK2YmgvshUPpMA==
X-Received: by 2002:a17:902:e74d:b0:15e:94f7:611e with SMTP id p13-20020a170902e74d00b0015e94f7611emr540547plf.37.1651792042915;
        Thu, 05 May 2022 16:07:22 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id om9-20020a17090b3a8900b001d5c571f487sm2076718pjb.25.2022.05.05.16.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 16:07:22 -0700 (PDT)
Date:   Thu, 5 May 2022 16:07:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <20220505160720.27358a55@hermes.local>
In-Reply-To: <20220505225904.342388-1-andrew@lunn.ch>
References: <20220505225904.342388-1-andrew@lunn.ch>
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

On Fri,  6 May 2022 00:59:04 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> It is possible to stack bridges on top of each other. Consider the
> following which makes use of an Ethernet switch:
> 
>        br1
>      /    \
>     /      \
>    /        \
>  br0.11    wlan0
>    |
>    br0
>  /  |  \
> p1  p2  p3
> 
> br0 is offloaded to the switch. Above br0 is a vlan interface, for
> vlan 11. This vlan interface is then a slave of br1. br1 also has
> wireless interface as a slave. This setup trunks wireless lan traffic
> over the copper network inside a VLAN.
> 
> A frame received on p1 which is passed up to the bridge has the
> skb->offload_fwd_mark flag set to true, indicating it that the switch
> has dealt with forwarding the frame out ports p2 and p3 as
> needed. This flag instructs the software bridge it does not need to
> pass the frame back down again. However, the flag is not getting reset
> when the frame is passed upwards. As a result br1 sees the flag,
> wrongly interprets it, and fails to forward the frame to wlan0.
> 
> When passing a frame upwards, clear the flag.
> 
> RFC because i don't know the bridge code well enough if this is the
> correct place to do this, and if there are any side effects, could the
> skb be a clone, etc.
> 
> Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Bridging of bridges is not supposed to be allowed.
See:

bridge:br_if.c

	/* No bridging of bridges */
	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
		NL_SET_ERR_MSG(extack,
			       "Can not enslave a bridge to a bridge");
		return -ELOOP;
	}
