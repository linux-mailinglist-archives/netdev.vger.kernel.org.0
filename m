Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D655F31DF
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJCOUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJCOUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:20:51 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FA240BE7;
        Mon,  3 Oct 2022 07:20:49 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q9so9788899pgq.8;
        Mon, 03 Oct 2022 07:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vF6jYskKFtL76I9VL7jQSPvHW3USZIrLaYZQO7sPj7s=;
        b=BhRHDiqGgUdQnMTRYUV11CK7hwH49qJkPSBtM/CDKWmjemWUSWbn0BUY01ojBhembD
         yH/w2D6+jUwSgtBwYWQ0hWL2v7LYDUHTHKWWPdqawHOQaBqJ2CpaMoBgCcGnNxPeW2SZ
         yjxsbIMmEFlTkmm8X1F9ELHDNneTWvWzOxLdEtVR2/lRkbQgag/oGDYAmEm3ilFUwZ4H
         ntIy1bHIAlxfI51n6VZCUOSeU4R6mftDD/EJmT1PBD9NVTlbNiTQHY3JejcTJXIdu+aX
         UmYkLF7fsH6rPTDwVYaA19FQOinV0y27JYd3SrZePQck4/X88iivUvC3u2rjNSsHXn0C
         DkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=vF6jYskKFtL76I9VL7jQSPvHW3USZIrLaYZQO7sPj7s=;
        b=3vgcqDYPmt+IdUastnBaRGYGMbDTcSGK421PfayEtgaevWu9YE/UgH6yEekO3MNk30
         zXyXim2ouKRt0KkUFDG/P4j19hGKdyUlAr4uVsbmwMja/Lr6dxNfxByK4xGiCu7PSJae
         NIcqhP0TWTp8O0Dvtf7iR7HVlZwClBNv8V06109vc4zZw4ebXB6JcH1z/UEjtFAEwjG6
         9SVYRRPK4/BFPWUT75kg8WkHesidhN24S/j3Db6c5WU0IGtpui+/sJT2Qelr/vkHx6we
         xeOLyVPZ+y7HXX1K01Ng7AtRz+P4pNGIVxbSw4wRbC4qeggWNI8VZLghhm2lE6cved7x
         u1iA==
X-Gm-Message-State: ACrzQf1fIrZbtheC1lK0kVB/D+d6jsjtbDR4H4AYFx9oPiZUpFID2OOe
        MiYx52PbL8vw0BJbyXZh5q5Z8yKbXZw=
X-Google-Smtp-Source: AMsMyM4nAzRILr9IasBeS8lmn4Z6Lth1mDgbD6QRrhKHx67ZFLJtnvnRGUhN8AG1OHIWFbFg2srjGw==
X-Received: by 2002:a65:4bc1:0:b0:439:e6a5:122a with SMTP id p1-20020a654bc1000000b00439e6a5122amr18772158pgr.443.1664806849078;
        Mon, 03 Oct 2022 07:20:49 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s4-20020a170903214400b001750b31faabsm7119081ple.262.2022.10.03.07.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 07:20:48 -0700 (PDT)
Date:   Mon, 3 Oct 2022 07:20:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
Cc:     Rob Herring <robh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>
Subject: Re: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Message-ID: <YzrvveFVh+Qt6TzN@hoboy.vegasvil.org>
References: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
 <20220930192200.GA693073-robh@kernel.org>
 <MW5PR12MB55988BE28F8879AF78B4441E875B9@MW5PR12MB5598.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR12MB55988BE28F8879AF78B4441E875B9@MW5PR12MB5598.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 09:29:00AM +0000, Gaddam, Sarath Babu Naidu wrote:

> PHC(PTP Hardware clock) index is a number which is used by ptp4l
> application. When a PTP device registers with a kernel, device node
> will be created in the /dev.For example, /dev/ptp0, /dev/ptp1.
> 
> When PTP and Ethernet are in the same device driver, This PHC index
> Information is internally accessible. When they are independent drivers,
> PTP DT node should be linked to ethernet node so that PTP timer
> information such as PHC index is accessible.   

Good explanation.  The handle you propose makes sense to me.
Maybe let the name spell it out clearly?

	fman0: fman@1a00000 {
		ptp-hardware-clock = <&phc0>;
	}
	phc0: ptp-timer@1afe000 {
		compatible = "fsl,fman-ptp-timer";
		reg = <0x0 0x1afe000 0x0 0x1000>;
	}

In any case, to me "timer" has a different connotation than "clock".

Thanks,
Richard
