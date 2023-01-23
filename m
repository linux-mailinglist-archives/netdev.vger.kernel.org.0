Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5BA677407
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 03:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjAWCXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 21:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjAWCXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 21:23:03 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4230D903A
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:23:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id bj3so10444152pjb.0
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GkzOKzoyBDw7fmqiJn3rmcSELX6mKBlkbPyDXBXi940=;
        b=P6c+tjsCbAMhwD4cFDCub6OnUKOEhkpOPsJ32sxWBuaX0EDZx2TchVD3O7sgeAEUVz
         BQOVTHgtRBArq7HSyuTjMnD9BCgvhFBBOFmWhO1xeRXI5/CPfWRvSieF8ML2B6Y0I4CO
         J30y+kb2YI5ISK7eMDLbcg5DgqU96TEE2tqoZM3AD6BzAU3TbpwuK4hPyWAYva8/72Wm
         W4DBYHco3gJMgp/hwSH8aWw4AnmNcFOvbndorIlAphrKrXuWB7H0I/rrHHo7Ti6n6wdk
         zCw2W1cYI5WDMThkh43wxqIj2PUb4LWR18X0DTU0dGj05WYYFFXjcdJ24AxGtEGq5WqD
         CmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GkzOKzoyBDw7fmqiJn3rmcSELX6mKBlkbPyDXBXi940=;
        b=Hsijf7HETv53fwU1HIefObTIL/xBaD93CEBX7k96nJtWfHzaTpAOV/d4cgZ3tmXzda
         aEXeo+lg/2AbOrPKEUv0YS9uRas1pSU/U1cqJ8SP1PHQnZHuNXkAMiEvU8umv6ownP+M
         psjTaelwr1xafUXXgqNZipHHe8s/tZtHWdv45J1605y8Q89qUCA+RQjtWhFcrKDpc9ay
         XVj4vN5nu1DZVDPvQoBhizeK06ClQtdG2IxcOz6nvwV+LV25hUR8keQeVQXxJ1ioAkhP
         ki7/9A4FCn/Y4zdACsvjOWwQtyo0hAOZ89meLRKq7/k7Ju+iVp5PP7uJQJvT0JoOip5p
         FcZQ==
X-Gm-Message-State: AFqh2kqmdAjZp9W+RyB8PUC9qC6+m3SYHLCvPWvlq6zUO9WCnfyp4aCi
        9yFyqZx8pWPHa0LHX3e1SY8=
X-Google-Smtp-Source: AMrXdXv2gNNak97Tc07hb57+PctOd23mO9JHScghfHZnsr7zZ6nLfopKuYkgu+UGAaFyvGeisBBQ8A==
X-Received: by 2002:a17:902:edd1:b0:194:6415:ced0 with SMTP id q17-20020a170902edd100b001946415ced0mr21352222plk.15.1674440581673;
        Sun, 22 Jan 2023 18:23:01 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902788c00b001898ee9f723sm2519227pll.2.2023.01.22.18.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 18:23:01 -0800 (PST)
Date:   Sun, 22 Jan 2023 18:22:58 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
References: <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
 <20230119194631.1b9fef95@kernel.org>
 <87tu0luadz.fsf@nvidia.com>
 <20230119200343.2eb82899@kernel.org>
 <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
 <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org>
 <87ilgyw9ya.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilgyw9ya.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 01:11:57PM -0800, Rahul Rameshbabu wrote:

> The way NVIDIA devices internally handle adjphase is to adjust the
> frequency for a short period of time to make the small time offset
> adjustments smooth (using some internal calculations) where the time
> offset "nudge" is applied but frequency is also adjusted to prevent
> immediate drift after that time adjustment.

Whatever floats your boat.

> However, we aren't sure if
> this is the only approach possible to achieve accurate corrections for
> small offset adjustments with adjphase,

Typically one would implement a PI controller.

> so I would suggest that the
> documentation be updated to state something discussing that adjphase is
> expected to support small jumps in offset precisely without necessarily
> bringing up frequency manipulation potentially done to achieve this.

Sorry if the docs aren't clear.  (However, the use of NTP timex
ADJ_FREQUENCY and ADJ_OFFSET really should be clear to everyone
familiar with NTP.)

Bottom line: PHC that offers adjphase should implement a clock servo.

Thanks,
Richard





