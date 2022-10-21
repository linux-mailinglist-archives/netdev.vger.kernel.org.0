Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC95660774D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJUMud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiJUMub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:50:31 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D8E32EC1;
        Fri, 21 Oct 2022 05:50:29 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d24so2269572pls.4;
        Fri, 21 Oct 2022 05:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0KlGUTvUZl89L8eZO3gvANACbFJz3GB1qo5LaPEgyIY=;
        b=gmYJEfCux9XE2yl97cPgtCIDDQKosLHOMgL8kKLEcnGRi4HI8ZWQvmKUKbaxoTREH4
         l5KvNT9c1qFjO3wNM3vdLmw9zynWL1jksJnmV/ao2ncyxcMn8U4rNZJCPfAb4kBz93qV
         5QbpC/rMmZKSYhURoQTSbtYxzYcR/XlFr15MvrC1TbFW0FM5/TkF8B+2EfSo15+cqi/R
         Ckzt91lQC5hTgYTyTW2ETBURgTaHgthCx4vy4QEZWm9xsHC+ydRbiHsQrybArlCFeNAJ
         BPw5AHDyCOkJVjCbeHxctg/TQ3ncEETR4nlOMAloTiPr8K+SCPRY6FCa0KS6PZo5FOx/
         DSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0KlGUTvUZl89L8eZO3gvANACbFJz3GB1qo5LaPEgyIY=;
        b=3YEf64LAaYo9iGH4A3u691Ub3A6vJxVy9Rghti8aS6xhmzk+K/OnRE0aGbhPpit5sd
         EPwh8vxhEAksPTWKpNa8hh8tP4/GaTK7+tgZtxx53cWoi+ifa5IN+pqw0YTj1DjxvtqL
         txg5Aku+BbDxBuJyeobZ5h+jUR8Q9ITzr/BDgCzT2iQrhwAr6mj6IBKKse1OfUUMujyl
         ND+qTYPolBDoHz9UE5qZS1lTH8u/B4eYmJLp3c0RK/AOz2cYsfmkWSI7z1GCX9GybRjQ
         1/qK8vFnTxlLuYLX8fAwqKzJok+gERBS085WmHMJsATGULPdq4mNvlNK/Beaio4OFrrq
         1IZA==
X-Gm-Message-State: ACrzQf0wivyTgKMmqjrH7B7WYkYeCS9YP9R1SJWJHqhO/kD7/Pcjw8d1
        IihgZ2Qt3mwzSEG2ug77RqM=
X-Google-Smtp-Source: AMsMyM5VtbQVLrxlDDH0TECkFcm7zJxpX3ZGD4GUkkz9eckNYZa8aAhB98yUWjsRw19TL45h4Y4/3w==
X-Received: by 2002:a17:903:11c7:b0:178:af17:e93e with SMTP id q7-20020a17090311c700b00178af17e93emr19100722plh.78.1666356629150;
        Fri, 21 Oct 2022 05:50:29 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902a38200b00177ff4019d9sm14701153pla.274.2022.10.21.05.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 05:50:28 -0700 (PDT)
Date:   Fri, 21 Oct 2022 05:50:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Message-ID: <Y1KVka41Kza3IOXx@hoboy.vegasvil.org>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 11:41:10PM -0600, Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.
> 
> ptp-hardware-clock property will contain phandle to PTP clock node.
> 
> Freescale driver currently has this implementation but it will be
> good to agree on a generic (optional) property name to link to PTP
> phandle to Ethernet node. In future or any current ethernet driver
> wants to use this method of reading the PHC index,they can simply use
> this generic name and point their own PTP clock node, instead of
> creating separate property names in each ethernet driver DT node.
> 
> axiethernet driver uses this method when PTP support is integrated.
> 
> Example:
> 	fman0: fman@1a00000 {
> 		ptp-hardware-clock = <&ptp_timer0>;
> 	}
> 
> 	ptp_timer0: ptp-timer@1afe000 {
> 		compatible = "fsl,fman-ptp-timer";
> 		reg = <0x0 0x1afe000 0x0 0x1000>;
> 	}
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
