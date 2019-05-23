Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350832823E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbfEWQMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:12:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33921 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfEWQMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:12:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id t64so3949770qkh.1
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 09:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CtOHb120sU9MitMB78DqBxaxz6iTY/poq+ov51fLwxE=;
        b=si832EXsSD5uSSO2hNwvXyagM9hYY57u+lsm0BXH5WRbqIXHUsJE8oBOe5z8xiU7hd
         sEGb59oLGgKFdK4DNNaUYEJAojJ/Wrv287dHj3xbjksVb9PpBUoshVyovoNaRRTG70N/
         YdHAS5HFeT+nm0dHKTAQD/QyQLbQw2lX1E5IP78BykZPEVwswnP/vpfh/R1NvWbTpVU6
         g5lRy+aov5XYayXQejCyqeu1ur/UiNZ9MGhFGlsneihTmi7QiK87Ws3fWQq57Y37zKoq
         7nPjq5nBBidyRRxImWCl0/GgxRncZ1hzrkP8qu2dWzYWRoWw84BRzKV1pYqMnsvNVrPT
         HkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CtOHb120sU9MitMB78DqBxaxz6iTY/poq+ov51fLwxE=;
        b=Fb2YSiarezuk+ctWXNJXElgYxSUAI3ns2YgPzKf/XSlWH17FTzSPe53pipRdzkdIlW
         IpUCGzDnnQy3Iq6q6BJ4GiT4ctAyhywkbqqlX2S6tmW4KP0i+DzDE5LQ8aj+EuAkVXgh
         JD9n7tAVQBiWlgmcYnW+fySJ17X756ftZs4QJZPGhZvfoMnUdIprx5ZbZUIZEYBzOEpi
         k4SAsQzm7vevqMOLYEQYJs7vN+YMJ2u9E9mo6B76QBi80wRugxaTCYprnAqcFGiPCSal
         WMvuJGD5eBezVPIFK+8RJt6C97yZfFuN+K/Ieq8p2ncPFeBJmjp4GPXrM8UHmkiiLQNk
         K7OA==
X-Gm-Message-State: APjAAAWoNQEbWcy6h30ybqwra1NeqkYIPyGWtxLR/bOprudnWE9DnYNh
        0GXW4CPWciMAE9EKXh7PJHjM3Q==
X-Google-Smtp-Source: APXvYqwzoqy+jduvNCyW9uSC9pwDJIpCyTt2G2s9jxx7cbr2hBpDEctkcyZYu74WG0nzKPrpD/AW5w==
X-Received: by 2002:a37:7a47:: with SMTP id v68mr75626472qkc.56.1558627921446;
        Thu, 23 May 2019 09:12:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o24sm13285496qtp.94.2019.05.23.09.12.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 09:12:01 -0700 (PDT)
Date:   Thu, 23 May 2019 09:11:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190523091154.73ec6ccd@cakuba.netronome.com>
In-Reply-To: <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
        <20190522152001.436bed61@cakuba.netronome.com>
        <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 09:19:49 -0400, Jamal Hadi Salim wrote:
> On 2019-05-22 6:20 p.m., Jakub Kicinski wrote:
> > On Wed, 22 May 2019 22:37:16 +0100, Edward Cree wrote:  
> >> * removed RFC tags  
> > 
> > Why?  There is still no upstream user for this (my previous
> > objections of this being only partially correct aside).  
> 
> 
> IIRC your point was to get the dumping to work with RTM_GETACTION.

Yup.

> That would still work here, no? There will be some latency
> based on the frequency of hardware->kernel stats updates.

I don't think so, I think the stats are only updated on classifier
dumps in Ed's code.  But we can't be 100% sure without seeing driver
code.
