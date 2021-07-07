Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBCE3BE887
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhGGNKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhGGNKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:10:10 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6586FC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 06:07:30 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id d9so3283704ioo.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 06:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P+p8MlTL+Ugums2wbllEtPvV46qbJoRofLeQP5kxHz8=;
        b=RBCF38Z9BoIserbyrC2TIsU2UE0NmC2IMtmcDMWweo1/VZHNzkNynCJ6a/aTwq7D1A
         86wGe/YtWI8g/kLI08XlN/BxFvFg7OTNWsi08T5jN1OtvJv3BHfiEjd1MlMt3vIGfeMJ
         QX/GJ1vGnCVesF/Yxlk3KFjyX0HkdqGFDY3HC4ifgaUYvZNAiIDnjCpPNSIbs6mvHCQk
         TxMeqtR+OWObrDfkxK4YvAiqsufT/9sBPWH8mzJJQMVZgUZY4HaWy5RgY+VTDTDyNuRh
         qZXpZ588E23ITPB60cJFLgVsHXTSe5pUtedACOZpMf63hOcBb8wRsoIpBr9Cmc6zWOIt
         NbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+p8MlTL+Ugums2wbllEtPvV46qbJoRofLeQP5kxHz8=;
        b=LvLHKPnzFUCLJ9wpVIQ5O3+FCGILl/4uBvLy7KsVf7JhBAQtg9URyraBdh/0Dkty1g
         KyErn4g/gD7/TmNWZkUuIda9b7qW5iKF3SlOc4JVIeLBoWby1BxcWBeZ4N+2/9SyNnzz
         cWJFhgXxWkHqRczKazDzMqJ+qvdY2f62NbbmyMVJw6qlpbHpEH06FMJSslDBlsjHx8uz
         nE3W0R+eGTru+NwKBS0I2QSvasTBSSFirJY5eeqF2DWu+czYUbdHcxVOKQIoZdnrhOfG
         sbywnI4vBhHjdp+ciFBiGfhwj1VOulmXHpm4mqbso7XKXLGznQ2f7kAgTQwIgm7w4/nM
         TP5A==
X-Gm-Message-State: AOAM530MtYV+55Blsjxs/VqAP9YAP89xstIS9UblpTsl/YZ4LmC2/iWZ
        QZ4MyHJpRh0DVkXZjKSyfMIZdjtqcJ3m7w==
X-Google-Smtp-Source: ABdhPJwQrf13ubadfe5m9Byloeyk5PEWe2nQLXJo8nOhxYt22e5MGCQqWrUAJuTIBVz6gl5pYt8zZg==
X-Received: by 2002:a6b:760e:: with SMTP id g14mr19857660iom.119.1625663249772;
        Wed, 07 Jul 2021 06:07:29 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m13sm10321697ila.80.2021.07.07.06.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 06:07:29 -0700 (PDT)
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
References: <cover.1625657451.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
Date:   Wed, 7 Jul 2021 07:07:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1625657451.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 5:39 AM, Pavel Begunkov wrote:
> Implement an old idea allowing open/accept io_uring requests to register
> a newly created file as a io_uring's fixed file instead of placing it
> into a task's file table. The switching is encoded in io_uring's SQEs
> by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
> think we need more, but may be a good idea to scrap u32 somewhere
> instead.
> 
> From the net side only needs a function doing __sys_accept4_file()
> but not installing fd, see 2/4.
> 
> Only RFC for now, the new functionality is tested only for open yet.
> I hope we can remember the author of the idea to add attribution.

Pretty sure the original suggester of this as Josh, CC'ed.

-- 
Jens Axboe

