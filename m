Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2430064497F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiLFQjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbiLFQjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:39:25 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931C83207F;
        Tue,  6 Dec 2022 08:38:11 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 140so15013608pfz.6;
        Tue, 06 Dec 2022 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hfcClvAjYsEYpD+4h6RMX/YIPLSw1G9BiIRrJFNAfk4=;
        b=KXfP8prqvi7t6JCcTiPTv6yJ/MwA4+4AJne/wv1wRVfUqBYThcA39M+4D1MYisj7c0
         Wsdpescis8qAUFF/rcPU3fSTzxwMh6KgoPVw0iq7ZT+r8kvFcNiRaRb+G3X+Yq1qrOuZ
         9NgysWOURLy9Wo/FrRbNPRtzbCYolauZC/opLExHNyQAT+N8A2ZH/efBF61znPY1s6UM
         LdHvF+mOSxszkOXhi816AZI+M8+PPj0mr0CuO6SNQIxMmgetik9z7pUF9bKUjFULIdGU
         4YJf3jJoxrTrv5i3zaCJLldrGI/2okXtomP8+03KIvTFtvHQ7Ut7rFv1+i/7+oJZMyHN
         VbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfcClvAjYsEYpD+4h6RMX/YIPLSw1G9BiIRrJFNAfk4=;
        b=uSrWKRIL/sUHAefMTkXNeU7NZ5+QMUkNO52ylUF/7mYJ3kYZvjQs6aiultwLsydozn
         R9GoUuJv8RJkRCML0tiXLV92hEyKscn2BFL5JtnQxOakmeBwQhNp5s9Ujdi2nMSbtgPj
         0onn8KDGYQo7KttjbiiPRm8fv74eVH5MMDd4A21CmPogvdFKNOh/icE8Kmt6Gt+HrvjI
         TzRSlkwLbKZkcOpc1kFtivFD7QstNWC5MaUXQKHkLbqP2yuTXARp4mYLLgy+gDVhbDUk
         nSP5Bonsoem6VnnM1ID5gR1ibVeNe9HGkuPZakUsZtWnZxhGOKqPBUV/AXEyIIhnb8bO
         HMeg==
X-Gm-Message-State: ANoB5pkYb9vE5X3hCgaA6HU+jPHGqGsWwU9O90BuYadlmSmbXnJWqLcp
        iF9YTII9Y2pyqWAVgfQMAVdwT+q6Rzo=
X-Google-Smtp-Source: AA0mqf6FHAnyNiQrJnlLfI72OPbCgJa84/hUs3hnOPdz63bC2TGFmci0WKtj0YxQgdjXynQMo4CYnQ==
X-Received: by 2002:a62:1792:0:b0:56b:e975:cf98 with SMTP id 140-20020a621792000000b0056be975cf98mr71987542pfx.63.1670344691003;
        Tue, 06 Dec 2022 08:38:11 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y67-20020a626446000000b005769436a23dsm6547820pfb.218.2022.12.06.08.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:38:09 -0800 (PST)
Date:   Tue, 6 Dec 2022 08:38:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, ceggers@arri.de
Subject: Re: [Patch net-next v2 06/13] net: ptp: add helper for one-step P2P
 clocks
Message-ID: <Y49v73+Hg7x3JhFS@hoboy.vegasvil.org>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
 <20221206091428.28285-7-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206091428.28285-7-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 02:44:21PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> For P2P delay measurement, the ingress time stamp of the PDelay_Req is
> required for the correction field of the PDelay_Resp. The application
> echoes back the correction field of the PDelay_Req when sending the
> PDelay_Resp.
> 
> Some hardware (like the ZHAW InES PTP time stamping IP core) subtracts
> the ingress timestamp autonomously from the correction field, so that
> the hardware only needs to add the egress timestamp on tx. Other
> hardware (like the Microchip KSZ9563) reports the ingress time stamp via
> an interrupt and requires that the software provides this time stamp via
> tail-tag on tx.
> 
> In order to avoid introducing a further application interface for this,
> the driver can simply emulate the behavior of the InES device and
> subtract the ingress time stamp in software from the correction field.
> 
> On egress, the correction field can either be kept as it is (and the
> time stamp field in the tail-tag is set to zero) or move the value from
> the correction field back to the tail-tag.
> 
> Changing the correction field requires updating the UDP checksum (if UDP
> is used as transport).
> 
> Reported-by: kernel test robot <lkp@intel.com>

How can a test robot report new code additions?

Thanks,
Richard
