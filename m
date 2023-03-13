Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2506B812F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCMSwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCMSwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:52:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635AA19B5;
        Mon, 13 Mar 2023 11:52:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so3575422pjv.5;
        Mon, 13 Mar 2023 11:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678733532;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TZAYmy7LtWkOz+9Lhtfq91ha62E2QuzGuoNk3jSQ7Yk=;
        b=VuW+AdrkZbTs9lW1ow8dP746ZE7bOQ4BSROmEuKDzzlvQ6UaKPWlif9ekrJ0NK2HeQ
         zYd2p85+2SCZiyLCYJEgsqIo/moYB7DpykCLJv6uXiVTUKKUwza8Gg0VR0qLeefe3EdJ
         3c4Z4YeGMTDPn9d1fpXFTB2QmgAOiGqTHVMCDR8jv4ajTJ6kj/8f4SSOSwLtQPF2Vfkw
         2XCj2r+izQYXAUajlyt8P2bT1jNzIj/+zDYZ6eNQlIFxREd09lfUr06Vb8skWR7SpgpX
         XUn/uecp/HI1Ble/TJKJ5yv9hkAN+8eUwY13hmH2xGWpi7qMEhR+obD5+UrhoKCCetqO
         fNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678733532;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZAYmy7LtWkOz+9Lhtfq91ha62E2QuzGuoNk3jSQ7Yk=;
        b=r5MwAHm34XSxSqGYtemgcsJeqFKhx8DN8fwdkCY2g4ED9aLu57a2O8g9rIAfx/B4Gz
         edp8OkN4qJyq6jHXYdsLd1rXqaNojqJSS7WZ7g1r71a0PjrsJ+r26iAQ9mPLGO91bhfh
         cGZy2ukPWUR6qVOtQtyb7nB6cKMBSsG904YDVFIqjRzp+Q/Ifn61n0NkcgU319KodOsY
         pq2+bgpqzZnkvmaOVPdU2QxUA9/hPU3f0OTKtm32segOEcVjcq7sNLoPHxiDfG+uS9OG
         N58LWLroD26Xu6fOA1whvYOOhul0NM4HgXwczlzCnNy3aiJOaptnpC8u6eHv5EfJK4rb
         aEWg==
X-Gm-Message-State: AO0yUKXLVvZHILEk/b+BIBYydMO0xSU7X2De4QQunGL/nHq4T1Kh2P0D
        nQAlBkYgoObQv6dzt4qBLT/ClZFy5i4=
X-Google-Smtp-Source: AK7set9sxyRfT1TT1ZF+1HeRhfTW3P9ZRv4sHcdvpXI1DpKmXWz7JMEAb0ivsEm8FaPq9j+BWEeWFg==
X-Received: by 2002:a17:902:f90e:b0:1a0:53ba:ff1f with SMTP id kw14-20020a170902f90e00b001a053baff1fmr2040280plb.0.1678733532480;
        Mon, 13 Mar 2023 11:52:12 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v7-20020a170902b7c700b001991f3d85acsm172329plz.299.2023.03.13.11.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 11:52:11 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:52:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ines: drop of_match_ptr for ID table
Message-ID: <ZA9w2T78IqLWk7ja@hoboy.vegasvil.org>
References: <20230312132637.352755-1-krzysztof.kozlowski@linaro.org>
 <ZA9PO82L1Adwtd7A@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZA9PO82L1Adwtd7A@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 05:28:43PM +0100, Simon Horman wrote:
> On Sun, Mar 12, 2023 at 02:26:37PM +0100, Krzysztof Kozlowski wrote:
> > The driver can match only via the DT table so the table should be always
> > used and the of_match_ptr does not have any sense (this also allows ACPI
> > matching via PRP0001, even though it might not be relevant here).  This
> > also fixes !CONFIG_OF error:
> > 
> >   drivers/ptp/ptp_ines.c:783:34: error: ‘ines_ptp_ctrl_of_match’ defined but not used [-Werror=unused-const-variable=]
> > 
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
