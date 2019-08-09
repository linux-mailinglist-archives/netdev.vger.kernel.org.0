Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0CE86F30
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405283AbfHIBPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:15:18 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:34834 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404985AbfHIBPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:15:18 -0400
Received: by mail-qt1-f180.google.com with SMTP id d23so94325782qto.2
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 18:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HBP9X7RUorDbuTgfP/iyR0ifbHJcf3sw2M1cV7/ckks=;
        b=dGtONh0iynJiFoCUldMFPFiv/T/0HB4saG1y1Tf34PmE3GefJpmGAztw9EtOWIsaJN
         mFw+HtaRYhRHL5NJyFzXFXhOzwCRcYOFBV9zqNc2+SxaiCygdPWWHdSAutCLW//F5Jyy
         26zM2UU9Z1cfQSXBkpuv5veUb0rzPURbPsHVfFdKuupHeRqXM//Ptm3ELKSmNRqp+OrR
         a365lP1c8Eya3XVa4MCue1t5Ek284iMyl5gPWEi90a/pUC3jg9l6CJor/AKeyZZgCFA/
         1hti4LdK59Z2909lULb9C4xK9hnpXj3NVRIse6PmvV/J1+Dg66d1Cil7RB/oDjTohN/w
         JybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HBP9X7RUorDbuTgfP/iyR0ifbHJcf3sw2M1cV7/ckks=;
        b=BITuFKSwo3SwowJGqnTa7+9UnlEsMmcespFAJDi89eW4ayDnZg4W/PKUn4kPEqv5UJ
         F0I1kEnkhhc23yCe/q4X/7PReGhYJ+SYhie3lJnNe5NUrEmhTRT0w2CvERLKQILGgSa3
         lpUgjIrU2VUS3Y+AwCXB7a9EJlExqzBZWpSCJk16Z8yXofqJt4ern2s18QaYuyQuqw2U
         ixTU9Wb4Sd7d3C9Qo5kVdoEY5sZs6HDWGbLD7H0qlsFnwnB/0tW/htbMIAwdKBKXKQgt
         EKOD7HEBkUlJmwF86PPOwxM1phUmLYGSjDjrTlFCErwBflxXOSi/DuJm6JxhzLiAW348
         qo0A==
X-Gm-Message-State: APjAAAU2fsd4mghQmU7UJHFm9ESzDnLcNvEjbnWcznvf/nG7NdQUuNQq
        I2O8IdkiVdA6Dy9RU09/vNoccg==
X-Google-Smtp-Source: APXvYqyEVKq1/oxegZS2NNqpyXUHMxezX1vr8mKrJfPwA+tzdlPv5Lixp8a3YiWU8BZGIsAVVNJWbg==
X-Received: by 2002:ac8:1a37:: with SMTP id v52mr10254233qtj.129.1565313317528;
        Thu, 08 Aug 2019 18:15:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s11sm39724873qkm.51.2019.08.08.18.15.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 18:15:17 -0700 (PDT)
Date:   Thu, 8 Aug 2019 18:15:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 01/12] net/mlx5e: Use flow keys dissector to parse packets
 for ARFS
Message-ID: <20190808181514.4cd68a37@cakuba.netronome.com>
In-Reply-To: <20190808202025.11303-2-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
        <20190808202025.11303-2-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019 20:22:00 +0000, Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> The current ARFS code relies on certain fields to be set in the SKB
> (e.g. transport_header) and extracts IP addresses and ports by custom
> code that parses the packet. The necessary SKB fields, however, are not
> always set at that point, which leads to an out-of-bounds access. Use
> skb_flow_dissect_flow_keys() to get the necessary information reliably,
> fix the out-of-bounds access and reuse the code.

The whole series LGTM, FWIW.

I'd be curious to hear which path does not have the skb fully 
set up, could you elaborate? (I'm certainly no aRFC expert this
is pure curiosity).
