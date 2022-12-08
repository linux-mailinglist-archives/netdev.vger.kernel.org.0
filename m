Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199F96474F6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLHRWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLHRWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:22:41 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70EDEBC;
        Thu,  8 Dec 2022 09:22:36 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so5653333ejc.4;
        Thu, 08 Dec 2022 09:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4a+PVkoA8Z92lXYrHGseetNxpkz9UtOHtgVID9mL30=;
        b=KklQU3bBmIM56W2+OvIOr+JxRrN1EA5hMcGjDrgmMs1dl+S9ND/t3sfQTLwXRCY5bV
         cHAUTgjBdQw6NHqIPqg8306QIji3OK66n4MAOsPGkZJQ6RR62bJs4TwJUSt7SeMv2mb9
         hSVXXMJwHqbwYGW/VlvkYHtCAEZ9IPhZZM2LPPmSiFDUfJVS1GPhAy4TO93bYSWaeXdr
         cc5OuRD7WH+u7FcvgHIj3LPhXJ8ww2iPr3suvtgYuPJjqGfOJO44O0TJ6L98Khcd8s6J
         6511g4Pt98ykk6TXU6nt99qUnVeezr/dkQFFkHq48Ug+8SkB38vlqVkVy5N9tsuINMTI
         2GUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4a+PVkoA8Z92lXYrHGseetNxpkz9UtOHtgVID9mL30=;
        b=WEyoY6Xa6OrxLHgEP3J9aQlhelhJgOLaM59hfMvDX/BLsvgdo2Z+t8R7JxkAfFRr7y
         dMCSF9PtXGrghKViub7NLGmQIK5MVzqYV1Gn9HpK3pqmlkjLQME0MVUe//pG2XsS726L
         6PYWat6z1819yLI5Kv1RvzqWDYC29SURX/fVIihDlTrV7b8kJTkRV8pmrFiI2lZqio5f
         vdUDJoBcud0NgbE4XQdyELaSY7FYZmGqh82MtxA+2v/oygDpEgQh8TVBQSD7DPzTDJnq
         EDh4OpOg0IJtLgt0UlfpvTqcV5UcCnspDRErUdbCy2a0poIrnL4zcQ0KR2mxP3oG39Pk
         O7AA==
X-Gm-Message-State: ANoB5pmmtk8GugH8+dgA+C/Ioomjyl906Y2rlkdSwO6C36rDwxTzCXYv
        VjmRuPZJLXg4kzR+EKCr0uY=
X-Google-Smtp-Source: AA0mqf5rklwcq9l2DFlnLhcbsEMxE+YgsksOaVo+7S0m7r+YVxS9ZDufWet97IzKxpRSRwkA6lGseQ==
X-Received: by 2002:a17:906:2a0e:b0:7be:9340:b3e6 with SMTP id j14-20020a1709062a0e00b007be9340b3e6mr2837801eje.43.1670520154445;
        Thu, 08 Dec 2022 09:22:34 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id bv19-20020a170906b1d300b0077016f4c6d4sm9914893ejb.55.2022.12.08.09.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:22:34 -0800 (PST)
Date:   Thu, 8 Dec 2022 19:22:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2] net: dsa: sja1105: avoid out of bounds access
 in sja1105_init_l2_policing()
Message-ID: <20221208172232.fldnlue35km76ldt@skbuf>
References: <20221207132347.38698-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207132347.38698-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:23:47PM +0200, Radu Nicolae Pirea (OSS) wrote:
> The SJA1105 family has 45 L2 policing table entries
> (SJA1105_MAX_L2_POLICING_COUNT) and SJA1110 has 110
> (SJA1110_MAX_L2_POLICING_COUNT). Keeping the table structure but
> accounting for the difference in port count (5 in SJA1105 vs 10 in
> SJA1110) does not fully explain the difference. Rather, the SJA1110 also
> has L2 ingress policers for multicast traffic. If a packet is classified
> as multicast, it will be processed by the policer index 99 + SRCPORT.
> 
> The sja1105_init_l2_policing() function initializes all L2 policers such
> that they don't interfere with normal packet reception by default. To have
> a common code between SJA1105 and SJA1110, the index of the multicast
> policer for the port is calculated because it's an index that is out of
> bounds for SJA1105 but in bounds for SJA1110, and a bounds check is
> performed.
> 
> The code fails to do the proper thing when determining what to do with the
> multicast policer of port 0 on SJA1105 (ds->num_ports = 5). The "mcast"
> index will be equal to 45, which is also equal to
> table->ops->max_entry_count (SJA1105_MAX_L2_POLICING_COUNT). So it passes
> through the check. But at the same time, SJA1105 doesn't have multicast
> policers. So the code programs the SHARINDX field of an out-of-bounds
> element in the L2 Policing table of the static config.
> 
> The comparison between index 45 and 45 entries should have determined the
> code to not access this policer index on SJA1105, since its memory wasn't
> even allocated.
> 
> With enough bad luck, the out-of-bounds write could even overwrite other
> valid kernel data, but in this case, the issue was detected using KASAN.
> 
> Kernel log:
> 
> sja1105 spi5.0: Probed switch chip: SJA1105Q
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in sja1105_setup+0x1cbc/0x2340
> Write of size 8 at addr ffffff880bd57708 by task kworker/u8:0/8
> ...
> Workqueue: events_unbound deferred_probe_work_func
> Call trace:
> ...
> sja1105_setup+0x1cbc/0x2340
> dsa_register_switch+0x1284/0x18d0
> sja1105_probe+0x748/0x840
> ...
> Allocated by task 8:
> ...
> sja1105_setup+0x1bcc/0x2340
> dsa_register_switch+0x1284/0x18d0
> sja1105_probe+0x748/0x840
> ...
> 
> Fixes: 38fbe91f2287 ("net: dsa: sja1105: configure the multicast policers, if present")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
