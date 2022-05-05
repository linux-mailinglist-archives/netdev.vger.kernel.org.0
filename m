Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1951F51C18C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378918AbiEEN5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354470AbiEEN5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:57:48 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C6957980
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:54:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 202so3683864pgc.9
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 06:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7lJqPMI7csNOtXo0+hpfx2r7ApbA9/UMzn+Hq7tqDNc=;
        b=fp1ao1/lI7QvmokIUTrhaWbFhIvPp5R9JV2qnBpXfs5vwz1df4z2vzcZON8iqzTu6Y
         wuf+Gb7Ka/kJPF24EaV1yAjcLw8Tq8VMoidiok2p8h/1fBZtGggD5aaEyOkZNxmVn3nU
         2gj2YAsk/Oi0Va0EZ9e6NerjJGdVXSzwHrEPCZuCATyGvo8KejjxsCquqzM92DhxY2Nf
         +4eZYENcOaGkfD8FwJ3PJqrAggEkw3k/9v2hwutgAKms0C1ViKqG+3hzWgLGyxJM7f+o
         4k+B41x4KGjbaXffkUb8aw0NKYyu8sNezzleXtnlgQu+32SgUkG9paFT8s6yduOO3zUX
         onbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7lJqPMI7csNOtXo0+hpfx2r7ApbA9/UMzn+Hq7tqDNc=;
        b=nH/TR5Aj6hXjukYaFPBmIhFD6EFMfIZU6OmegSLNDv6TfRyCbkaDGV6QdMVbu8uYEx
         vFQcXxH7hrXrlQ90nJ0PYHvL00K2PyIO6hXTOBNCKURIHeadlELY6U01z4HY7xwJiDFz
         atU+pQC6vLcUcQkVqpopUyXMLqIfBPVlzQFr0PfQ5p3U/21gKnDocB2boXh0AmPJsJ20
         Nk6o+KYUKZkAnCpiT02a4pgoUKGaeWyMaVZsbc3HRsP3X/Jet1zhVTzInfcZo7oSCADO
         2u03YQI8O14FVBZ2fH5M1zoRRaNw4hdSkkzVCexGFyqhOZTLio19Kw6gO36tFdPlahdW
         Meng==
X-Gm-Message-State: AOAM533NbWMxggh0g3saaLoNiQVmi8k4CWeRZN4wf0ybiePDw1TwYiST
        EXxsuB+nzSkkCqG0Q3Ovm+8=
X-Google-Smtp-Source: ABdhPJxPOvFG+f2Al13lVBss79UfL7ZIcbCmOIIXYdd11sk7F2xQdtoq/uSDsT/1XpXoetjCtmi2pA==
X-Received: by 2002:a05:6a02:197:b0:382:a4b0:b9a8 with SMTP id bj23-20020a056a02019700b00382a4b0b9a8mr22395853pgb.325.1651758847110;
        Thu, 05 May 2022 06:54:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y4-20020a170902ed4400b0015e8d4eb290sm1549746plb.218.2022.05.05.06.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:54:06 -0700 (PDT)
Date:   Thu, 5 May 2022 06:54:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/6] ptp: Request cycles for TX timestamp
Message-ID: <20220505135404.GB1492@hoboy.vegasvil.org>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501111836.10910-3-gerhard@engleder-embedded.com>
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

On Sun, May 01, 2022 at 01:18:32PM +0200, Gerhard Engleder wrote:
> The free running cycle counter of physical clocks called cycles shall be
> used for hardware timestamps to enable synchronisation.
> 
> Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
> provide a TX timestamp based on cycles if cycles are supported.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
