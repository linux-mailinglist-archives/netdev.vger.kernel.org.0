Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A184E646E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346229AbiCXNxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240823AbiCXNxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:53:15 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E70A0BD0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:51:44 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b13so2157334pfv.0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bQu9CyB07PzvsCBVAksc641BaYFKG8GRbzDkv/L+7zQ=;
        b=kQVTmkX8Q3ihqVLWN8/fc9lviLtzjzlFG/S3JpIusRCHQx2Hi8jLOEuDH9Af7QzmTg
         i8cHD0YoAH/tUCwxEVs49hJTJsYDXWCpxnT0p+Q0wyhI1bdg/UP9//3PFXWRZKS9daDN
         mZUhiz197TbBKvOfjP7VvypkAfMLTKd6N3A0VsD5HxwCZfEk1M00+uvoUhJifv0lhTpj
         2H+HJSThe8A1cKW8qoqMmZoKNBvASVfAQDyLlkwajf4MqShUO41tUfn+zIKvS900ulVu
         /7B+U8qIZLnnuhdRKrIBgVdUsJ00ZAM9MggH+GNTmzUdCsnuD3W55Irli/lFYGQrnsW5
         mQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bQu9CyB07PzvsCBVAksc641BaYFKG8GRbzDkv/L+7zQ=;
        b=KuSk89oyTfcZeuDlH8R4yPSF3TL+zaC43BI7XhzqJ2qHIuyu+hhdkQKRNRCeofr/O4
         AfbyKgDI6mFB2+p2LffnowoHiLfLaS1yflhXBmaDeuT/4UPE2FV9YTZo/8mZ8nmPxdFp
         EMvwUDtctjt7HjhHYnwSOmTOOPI5GnlXYDnvMEzeUvV6IOyBDOrcy5K/9rtGjav/jcyQ
         4IRUZkDdJyNO/T/4H3lOWGd6J9rxixPNPVmeKZjctVsHApzI7k8qR5tQEiwaU0HoytxO
         SUAHQlBs9yFXnce/YVFuTm9bAlgNK7yqj4yvVD15/Myf9BOWOzBLVdG63SOsY+MEVZJR
         RJtg==
X-Gm-Message-State: AOAM531XAg63ALIf6QwG3yJ40npMHYBNxj7MapJEp5NrfyXjnFf2W1DQ
        mczfYOYAPmsBaagEOzdd/HQ=
X-Google-Smtp-Source: ABdhPJzihrbDqfXdoY51T8KKiNQpLQndBewKjw7uhQU3QCGDpPvUq1Xiyq7jqfuWf8iatjyS8a6KYQ==
X-Received: by 2002:a65:644e:0:b0:382:800d:153a with SMTP id s14-20020a65644e000000b00382800d153amr4142376pgv.366.1648129904009;
        Thu, 24 Mar 2022 06:51:44 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q6-20020a056a00150600b004fab3b767d0sm3515197pfu.30.2022.03.24.06.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 06:51:43 -0700 (PDT)
Date:   Thu, 24 Mar 2022 06:51:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/6] ethtool: Add kernel API for PHC index
Message-ID: <20220324135141.GD27824@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-5-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 10:07:20PM +0100, Gerhard Engleder wrote:
> Add a new function, which returns the physical clock index of a
> networking device. This function will be used to get the physical clock
> of a device for timestamp manipulation in the receive path.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
