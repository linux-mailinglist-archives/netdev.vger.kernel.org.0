Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C984DE794
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbiCSLUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238827AbiCSLUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:20:46 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4247C19455D;
        Sat, 19 Mar 2022 04:19:25 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qx21so21345097ejb.13;
        Sat, 19 Mar 2022 04:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=e3nGMUl97AolwKtGzCQqE4uRUav6yCj428FNvX0CaSY=;
        b=j0ZWvP6syf7s2uOB5rdwanjddjdHcRCdRn1EwQl8QPJicTDpJBrdjgMTI3KSy7FiR5
         /SA5Aa+EPp1mngoEsTuLD0BwIiryiluH5nm2sSkEo0TwLdIbbr1lhA4EzUwzfQw8uX8o
         nTEovlNW4PkrxSR/7SSDCOu9U4F8+jCM8+Ia0eouwxRAKP9uegwHM80Z5ekxFvczK+xH
         STOn4vaNtDTT2Dwna4ft3eaJ6G2Ivyic7W6WDtW4WSXQ9wtnvEc1O0/qB2kR36oB1E83
         Jmn1tP6QYWVsuezuh67MKJH6AdlFa8F1eR3vo5I7bIPp7G2O8lOwKDDNHYMAewq5ZlZ5
         yR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e3nGMUl97AolwKtGzCQqE4uRUav6yCj428FNvX0CaSY=;
        b=xNJF8sRJZ6xjrQQnnrAbRbp1m41zyxGD2ISTAEqHTbPirmWdnUXNuBSmEa7lXKz59Y
         bV3YijGH3Ku7H1cwkjG4cHavTnHGTgUFY6a5vZWlpO65AjHn27Le2M9YkbsndVrZ57p4
         b+zpN9CFa5/sJEwBdzv2BKpgl1Bkqz5WuPzQ30wef3rXaiQY7XkT5zzTGFsCOoik1ut6
         Voc+ST/iQNkjxOJSy9xvw8aVDveQHBiGDv551Vd1zU/p6SO5ISvbD+796jljmlPTujzp
         BDS9JDMWc4enFvAS8JRCJcvsjy0Eum6sLGK6fM7ae5YMk08Q2KEaA/pr7H1+Rf1cMSRb
         OsUA==
X-Gm-Message-State: AOAM531Orr5CL+MjCtmWINixcH8/Vtl4TMwdUjqWBNngAGvnTsmNojiT
        YQ28BkNjWwfbG4ZyFgh118Y=
X-Google-Smtp-Source: ABdhPJzwgGvUiIBXgOx5GENmRIji1rH7Cam9DIZVs8PzT8jPFWjKa2QU8uLoptOiuzkpYy0zttH2Cw==
X-Received: by 2002:a17:907:7f0c:b0:6db:bb97:97df with SMTP id qf12-20020a1709077f0c00b006dbbb9797dfmr12691192ejc.59.1647688763470;
        Sat, 19 Mar 2022 04:19:23 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id f5-20020a1709067f8500b006da68bfdfc7sm4689370ejr.12.2022.03.19.04.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 04:19:22 -0700 (PDT)
Date:   Sat, 19 Mar 2022 13:19:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fill in STU support for
 all supported chips
Message-ID: <20220319111921.npncivdemtosrgge@skbuf>
References: <20220319110345.555270-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220319110345.555270-1-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 12:03:45PM +0100, Tobias Waldekranz wrote:
> Some chips using the split VTU/STU design will not accept VTU entries
> who's SID points to an invalid STU entry. Therefore, mark all those
> chips with either the mv88e6352_g1_stu_* or mv88e6390_g1_stu_* ops as
> appropriate.
> 
> Notably, chips for the Opal Plus (6085/6097) era seem to use a
> different implementation than those from Agate (6352) and onwards,
> even though their external interface is the same. The former happily
> accepts VTU entries referencing invalid STU entries, while the latter
> does not.
> 
> This fixes an issue where the driver would fail to probe switch trees
> that contained chips of the Agate/Topaz generation which did not
> declare STU support, as loaded VTU entries would be read back as
> invalid.
> 
> Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> Reported-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/mv88e6xxx/chip.c | 48 ++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index b36393ba6d49..34af6f46141f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -4064,6 +4064,8 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
>  	.rmu_disable = mv88e6085_g1_rmu_disable,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
>  	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
>  };
> @@ -4184,6 +4186,8 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
>  	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
>  };
> @@ -4273,6 +4277,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
>  	.serdes_get_lane = mv88e6341_serdes_get_lane,
>  	/* Check status register pause & lpa register */
> @@ -4329,6 +4335,8 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.avb_ops = &mv88e6165_avb_ops,
>  	.ptp_ops = &mv88e6165_ptp_ops,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
> @@ -4365,6 +4373,8 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.avb_ops = &mv88e6165_avb_ops,
>  	.ptp_ops = &mv88e6165_ptp_ops,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
> @@ -4409,6 +4419,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
>  };
>  
> @@ -4455,6 +4467,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
>  	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
>  	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
> @@ -4506,6 +4520,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
>  };
>  
> @@ -4552,6 +4568,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
>  	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
>  	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
> @@ -4651,6 +4669,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6390_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
>  	.serdes_get_lane = mv88e6390_serdes_get_lane,
>  	/* Check status register pause & lpa register */
> @@ -4712,6 +4732,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6390_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
>  	.serdes_get_lane = mv88e6390x_serdes_get_lane,
>  	/* Check status register pause & lpa register */
> @@ -4771,6 +4793,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6390_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
>  	.serdes_get_lane = mv88e6390_serdes_get_lane,
>  	/* Check status register pause & lpa register */
> @@ -4833,6 +4857,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
>  	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
>  	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
> @@ -4933,6 +4959,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6390_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
>  	.serdes_get_lane = mv88e6390_serdes_get_lane,
>  	/* Check status register pause & lpa register */
> @@ -5084,6 +5112,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
>  	.serdes_get_lane = mv88e6341_serdes_get_lane,
>  	/* Check status register pause & lpa register */
> @@ -5144,6 +5174,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
>  };
>  
> @@ -5186,6 +5218,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
> +	.stu_getnext = mv88e6352_g1_stu_getnext,
> +	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
>  	.avb_ops = &mv88e6352_avb_ops,
>  	.ptp_ops = &mv88e6352_ptp_ops,
>  	.phylink_get_caps = mv88e6185_phylink_get_caps,
> @@ -5466,6 +5500,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 10,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5532,6 +5567,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 3,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5576,6 +5612,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_internal_phys = 5,
>  		.num_gpio = 11,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x10,
>  		.global1_addr = 0x1b,
> @@ -5599,6 +5636,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 6,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5623,6 +5661,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 6,
>  		.num_internal_phys = 0,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5646,6 +5685,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 7,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5670,6 +5710,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_internal_phys = 5,
>  		.num_gpio = 15,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5693,6 +5734,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 7,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5717,6 +5759,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_internal_phys = 5,
>  		.num_gpio = 15,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5906,6 +5949,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_internal_phys = 5,
>  		.num_gpio = 15,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -5951,6 +5995,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_internal_phys = 9,
>  		.num_gpio = 16,
>  		.max_vid = 8191,
> +		.max_sid = 63,
>  		.port_base_addr = 0x0,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -6024,6 +6069,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 6,
>  		.num_gpio = 11,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x10,
>  		.global1_addr = 0x1b,
> @@ -6048,6 +6094,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 7,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> @@ -6071,6 +6118,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_ports = 7,
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
> +		.max_sid = 63,
>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,
> -- 
> 2.25.1
> 
