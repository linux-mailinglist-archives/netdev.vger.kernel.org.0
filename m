Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DAA304078
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405847AbhAZOe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405682AbhAZOez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 09:34:55 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECBDC0611BD;
        Tue, 26 Jan 2021 06:34:14 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a9so16706068wrt.5;
        Tue, 26 Jan 2021 06:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WQgoOzkoghLE6Txd+mKAF3gxLvF0S/uKlI4N69soRhE=;
        b=jxs8HxFpIg6YPigYvawjbGoE/XfEaYCF0qSAav6v8xWlLxSCXeihY19oqSMp20Qq7d
         5JROpMbEAV11YeCHFf6RIPvnFqiZgVba9NoEq6Pz8EV0rVH0ud3GqwuCp2K4i7vZoUWV
         I4TFk6qtfrPdqDRqzg3W2S4TS2aoaWMEM8JHUDSoS6pmVFt0faInjGBlR7ntwq5SYXXd
         uSqJd7R2T1NqVN7BMhYQSvxgJW2pyeqeI40lHGHgRmJVqUOgoECh3grkYXoe9XZGRwq+
         noWspL0I6ThQmJrqo0iNr7OflvdxwtwK31fVhuiICp2tVzZ4KH8N8wO86BCLJtqTw+J+
         XG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WQgoOzkoghLE6Txd+mKAF3gxLvF0S/uKlI4N69soRhE=;
        b=TF4t0By/7dg+KhYK4+Wbrxd40HMgU9ZWZjNCbf/jiGZADFSaPuy5W5V3mbRweuS1Uu
         ADF9YZunQyQUXvuwkf9WkXUS2V3ynVACx+yQMuGGDkX7NoYr8bIBWx3Bv2wO1jQ65OPp
         yAVd3E0YgEyjYv3zMAVDlrgN8YKqsJobbVTdhWi/3C/Nq3yceq9KCKws/ZLGhqPDb4BL
         TsEdXrp08cM2UkwbdbAgYNRx6N9sRVzyWJfic/xbRU9AojNrEfOakxZaK8/ks30Hb+sr
         uWtXZMYacIRQYKs/GseajnEInDi0XupbxbNvvvuV92bdSY31VxcvF0/91lrTirOtYDAA
         Pe2A==
X-Gm-Message-State: AOAM530euBPULtagC8q2xX+zSAPWZF/fB0tweOGza8xCn4G6cLM6Atz1
        OjBSNoHaFVC9X2Um/hRxO6z+rv/MEm05n1tA
X-Google-Smtp-Source: ABdhPJwXvKqZTEvMYDKx36YVJRsaxgeOq/5KAZqLeD5x+8Tp1TDkENk/jKQveqLCyeiuRKGPo4UYgQ==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr6321160wrl.421.1611671653231;
        Tue, 26 Jan 2021 06:34:13 -0800 (PST)
Received: from anparri (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id s23sm3350129wmc.35.2021.01.26.06.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 06:34:12 -0800 (PST)
Date:   Tue, 26 Jan 2021 15:34:05 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] hv_netvsc: Copy packets sent by Hyper-V out of
 the receive buffer
Message-ID: <20210126143405.GA1364@anparri>
References: <20210126113847.1676-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126113847.1676-1-parri.andrea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 12:38:47PM +0100, Andrea Parri (Microsoft) wrote:
> Pointers to receive-buffer packets sent by Hyper-V are used within the
> guest VM.  Hyper-V can send packets with erroneous values or modify
> packet fields after they are processed by the guest.  To defend against
> these scenarios, copy (sections of) the incoming packet after validating
> their length and offset fields in netvsc_filter_receive().  In this way,
> the packet can no longer be modified by the host.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org

Please ignore this submission, I'm sending a new version shortly...  Sorry for
the hassle.

  Andrea
