Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86EF638B7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGIPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:35:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35674 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIPe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:34:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so12947139wrm.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ubxm2QjL2XtS37GeBcWo9h3MpH5yGmC66HSli/ix0qg=;
        b=SXJCRkZUHIoqDMAklrBRzsKKBdJ+OgAsTOi2zzNL3GqTAkQ2iaiOn/WId9il45KYWI
         zx3A5+gyIb37jzaKLJocePHy/4ETLx9d1tcF00+JC2sgNyoxARS/kdHAJWwVGD42RB2z
         2B+rvN5gmBhVUg1zmr9xKduolq6YB7w/HwiRMzXiIXpbaRXtlj6kJWyocl6h0J+JtXcW
         Fx/FZPTmoOYlTdwT0mTWjKhDkexf2CZRJ3MI4RUIQqxNdoHS5QrqALTudH67oFd/8HNE
         uXs+a4IvkSRthMA37YGuSDK90VvtJRMEllEynnZXZCdjfFNhI9IBr5CJ/3B155QvU9RA
         ovZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ubxm2QjL2XtS37GeBcWo9h3MpH5yGmC66HSli/ix0qg=;
        b=HqcTnsK63mihCor15tNubazVAIFzvMXAsoMcbInSrfleYrUfLlnAQ6FVeZT7W515Z8
         wy4Op6hT5T1pwDRtHRZgQzSorabQ/i+ON3/u+y54kc5WsN/mnjXB4tMu9eVy2j55bNz2
         iaZDYVKJHPoPPH9/QmNNf2hzjeggRX5FLq8Vy5fVF0r1SDnJNKcYyrEsy+aubOTsO4Z+
         oD6uKo3E+4cEtjQVooiziBc3XEo/6hbTTyV/SrWReVan0M+rjYk7ai788ehPoolqcKLc
         qTXnDiTuQSYMC6gAta5sV1KXuPovt6E30h6J/ZCQXOVQq6PMDe5mvoq+u+Ymkqwx7l5G
         kWPg==
X-Gm-Message-State: APjAAAV2vnjpFsaXzgUcxEd/1lyD8y4cHClUoMh94tMU2wE5MBQG6csZ
        xBrOt4vRFYJqFaSMCZvgfjZDIA==
X-Google-Smtp-Source: APXvYqxVxobgorlhubyL1YCEvOLyZkZEgG05tm2oBTrTP307kXqMyHC+kDhJ0GNq/Pj+293NJ1gBNw==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr27474401wru.27.1562686497818;
        Tue, 09 Jul 2019 08:34:57 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h9sm17559652wrw.85.2019.07.09.08.34.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:34:57 -0700 (PDT)
Date:   Tue, 9 Jul 2019 17:34:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 15/16] net/mlx5e: RX, Handle CQE with error at
 the earliest stage
Message-ID: <20190709153457.GH2301@nanopsycho.orion>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-16-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-16-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:07PM CEST, tariqt@mellanox.com wrote:
>From: Saeed Mahameed <saeedm@mellanox.com>
>
>Just to be aligned with the MPWQE handlers, handle RX WQE with error
>for legacy RQs in the top RX handlers, just before calling skb_from_cqe().
>
>CQE error handling will now be called at the same stage regardless of
>the RQ type or netdev mode NIC, Representor, IPoIB, etc ..
>
>This will be useful for down stream patches to improve error CQE

I see only one patch left in this set.
