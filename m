Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE8DDFA7
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfJTRI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:08:26 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:39696 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfJTRIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 13:08:25 -0400
Received: by mail-pl1-f177.google.com with SMTP id s17so5351646plp.6
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 10:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bJM7HX5nleUrStsC5HzhJm/xcOrc0sqhwssM1i1iIPc=;
        b=S7A+dmD/WOJJmuAIgqfS81XxPmgoJD1yV1zxtVnDaAlRwsZHJHV0PKfDU/o6guzMxs
         GeGte/zs+EJAFIcnomG5ID9Oe1nYUfpJLtLXZbmmWswW7XwNG+N3r/amM/fK0y5HKaTN
         FglUZ/OIvJt7zcIA5GZ+ejUu74KZ9HhPZB0FPbs21RgU9EAu3C6F1QlxYTwPZhSUMjsW
         ArScFu/97jIH0XB93RghUmDJsW4zywkMVqe0zzSGnNc41S5ccAoqAyDkTMVaZvE0jtAi
         6KSH7IFT3safbR8NTeL+ACeHy7RtEEh/j4ib8UHnX4UKlt7ge0hfhyjpRszTywJ6F0Hz
         09ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bJM7HX5nleUrStsC5HzhJm/xcOrc0sqhwssM1i1iIPc=;
        b=UOOgK+vLu1qgQ+1LtC+Z3jiyIAxYFbGGcVV12N21Ha/sP7Z84Bip1P/yhZip04JnHc
         giZIzwktqkxjAnHnXGORD4ad/bi7Z1QgS+xtHHpweGwUU6DPHM6L1Zywz5n/oPMddWU2
         03djGJ5eTwXHGKPIkKf6LAOzjp5b8lRJaLpfxB54ZHUxYh/jbTSPEuMutIPkQhcRQv2b
         iwtfv+X//KOfqNZk6DblzJgxJsgQBHG4kS9mNtk73WeaZXTaCngSexDtVrDHfc2/SQ/C
         I3NCe67OWZnxOrpUx8tCqkXklOT54+3Fr2Q+1NRjp6iM10xhvlGDcGgxDU0SRXe1CXoA
         fsvg==
X-Gm-Message-State: APjAAAUXSFMWORwWiDjxCHVqSLLLGUkGywMASwjrk6ZEG9L9FpEWQ5B2
        756U08wNNGZMoVjkHFjd6Y69NQ==
X-Google-Smtp-Source: APXvYqxhxzr9VX1EE66SQf+w3yF/aCW+AZAL10kQ2bZbTRxtUnx9A05j+lqnv3wh03ibbcZGag0f1g==
X-Received: by 2002:a17:902:a70f:: with SMTP id w15mr20531545plq.146.1571591305159;
        Sun, 20 Oct 2019 10:08:25 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 16sm12136536pfn.35.2019.10.20.10.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 10:08:24 -0700 (PDT)
Date:   Sun, 20 Oct 2019 10:08:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net 11/15] net/mlx5e: kTLS, Save a copy of the crypto info
Message-ID: <20191020100821.01d4c712@cakuba.netronome.com>
In-Reply-To: <9f2465b6-9bec-326b-8939-ff9d2a6d5bb4@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
        <20191018193737.13959-12-saeedm@mellanox.com>
        <20191018161614.3b22ed45@cakuba.netronome.com>
        <9f2465b6-9bec-326b-8939-ff9d2a6d5bb4@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Oct 2019 07:46:00 +0000, Tariq Toukan wrote:
> On 10/19/2019 2:16 AM, Jakub Kicinski wrote:
> > On Fri, 18 Oct 2019 19:38:22 +0000, Saeed Mahameed wrote:  
> >> From: Tariq Toukan <tariqt@mellanox.com>
> >>
> >> Do not assume the crypto info is accessible during the
> >> connection lifetime. Save a copy of it in the private
> >> TX context.  
> > 
> > It should be around as long as the driver knows about the socket, no?
> 
> The crypto info instance passed to the driver (as parameter in 
> connection creation callback) might be modified/zeroed/reused, so the 
> driver is expected to save its own copy, not just the pointer.

Can you point to a code path where that happens today?
