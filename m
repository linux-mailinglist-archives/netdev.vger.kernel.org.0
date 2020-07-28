Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8C230A59
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgG1Mht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgG1Mht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:37:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175CDC061794;
        Tue, 28 Jul 2020 05:37:49 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t6so9839619plo.3;
        Tue, 28 Jul 2020 05:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fie8IAXWZ8a1f4IBdyXwUsTRAo2+ebUYgUxfo3SFpeA=;
        b=qHe7dAnwegbl8DFADwHo8PEhSZ+7zbY4GEkjbh4YRgoBOr7ttuUIZd3W/lLbgvLXtH
         Nmw48d7CCQlwK/k1SgCBId7AiMOZT4EXk0h2LojeErsKRtc6QPNKwLxAhFQd6hR5NDyh
         9oHwM248bQKXcys1dFKO9l1neCAYAMuaCiwJCWlW/ZkIe96vqwtjeAMSYa2tbq9x3o88
         BGtALXe6t+2pHo3RJtR9tsUzxejGbCniBGGmlSIs46uPSGgc49ttoIf+wh2we7OmML0/
         E/BVTKjEZGGX3/hQPfkvDwAN/xv8xFQbuW6LGOAazLbs95E03Y8rFQJ+pEPZpx4h4qn+
         vIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fie8IAXWZ8a1f4IBdyXwUsTRAo2+ebUYgUxfo3SFpeA=;
        b=Srm8REEYxDbNUbtn2GW2+NCxmm0I6HMIkk653gBd7B0CkAI5d1ZjgLcQxRTJT6FS6b
         6UhXcB7vxRYiny1Tb8oqLldRuCCwq2Bd3C8780zkhS2EXt7ppTOFuFr4rPZsy/nRv1Vr
         ditYw01lLGQ3E1Eyl3AGpFZpzAWS6g50CEDt0WNt3BkvHMr/mFJ2SRrIjf5YgRgv3wwr
         rkfdT1mi1nHBmxYmZv7K5zyfTVfxscYt9o+jxosWSjBvSZYPE++F+sf8Sb/TpBQxl/qM
         VS7uGn4JV2MF16KODq9uWFkCMxxzV9S+/OcRoUVddKN3kkXDGBV6yIi1uhxKN1wJCAVt
         52Ng==
X-Gm-Message-State: AOAM533rwH4/r90hOa8wVpPp8BWIPpY1UjLV1w3JgL56h8BMfN12slhM
        6mSZ8wNEJ8Z0Gg0UE5ECvFM=
X-Google-Smtp-Source: ABdhPJxMwzS10JHnifAZmdNYC8YAZkIcOFzizwBro4Xw8cdcIQLhzKEz7J7HdS2SEjQ2Po+YluXXBg==
X-Received: by 2002:a17:902:7b90:: with SMTP id w16mr21425536pll.253.1595939868491;
        Tue, 28 Jul 2020 05:37:48 -0700 (PDT)
Received: from gmail.com ([2401:4900:2eef:ca92:3545:4a68:f406:d612])
        by smtp.gmail.com with ESMTPSA id l134sm18030158pga.50.2020.07.28.05.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:37:47 -0700 (PDT)
Date:   Tue, 28 Jul 2020 18:06:19 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] farsync: use generic power management
Message-ID: <20200728123619.GA1331847@gmail.com>
References: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is compile-tested only.

Thanks
Vaibhav Gupta
