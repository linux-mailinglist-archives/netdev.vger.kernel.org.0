Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9ED2722C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfEVWUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:20:06 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35010 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfEVWUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:20:06 -0400
Received: by mail-qk1-f194.google.com with SMTP id c15so2602832qkl.2
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 15:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mSTs+cHipfnep7Si7txezrxCcEURdMsg9lXdHLhSvl0=;
        b=XX8RYMB0zi1E6onzuw9NF1WzxGTMJuOSJMzhZT0eSqvuPBcC0yT6oWC5BAJ5l60Q4r
         LQHjO5EnnN++MQqn8uxIZg8sw2SKp7Mh8oV4emvh9VyVQCVTt9fpzQVW3cGl4hu1n1Rp
         pu3U6DF6QZXBwI3gUbE2DGEs6jKR4ZDCcZ/LU0/e2rOu7IrbFY1XywrPiUWTYPw5f96v
         MmCHsiICcKTOWhz5UQFaCXlmgrRN2DSBBef1q24fb7ks91EK8JnalGAkJFMrwD2e5sLV
         mbYKDPS+Orr061jvwqM5cEDzdxZO9CbBYQzsUVoocgrYhpElj4BYBTj7Z9D4hUgeGi6i
         lbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mSTs+cHipfnep7Si7txezrxCcEURdMsg9lXdHLhSvl0=;
        b=X4GT7wecpHrS8evCkjhkVRer07r+mYMetcew5UkUO7fgFtq7nvRTG9UrmKZ3gG3M/6
         e6x520ToweOiLN8v1WzBlCXZ2NC0UEbsVR1vZIIPH6QfDH4c5W8Bq75TxAi0dWc6nZCn
         IMwu0VjwvMV9LpxdAII6VVhPey8ThYjBqTMpqseB5h9RrfOuwRfEXyVjP8NGN6ERAtyI
         wkt5/5f5WXPh3JB/h9ViAgMD3oi4LTpKmBxWLpq6I/dBqzcHW5+52gwheukdjgTUtWKt
         LamG1QMjwC4AJsxLxt9SkZeNEuGmym+I7JmxmE3q188LKTIHLrEjtIKnNUOL4aKBga8F
         w5XQ==
X-Gm-Message-State: APjAAAXv7U3wc0MT9E8BwIHJD86CiGzCYJYjMW3oL+9kGu7y/0j/hl5K
        VbFxxfAPSPuZQy7sEHShPqZOqA==
X-Google-Smtp-Source: APXvYqz25QBlr8ITlr3K4GbmL7NawQnUv08ZQGWZ3BU7v8XZPEjQ9586/OWdv7WlzmflrCG1zO5w0g==
X-Received: by 2002:a37:72c7:: with SMTP id n190mr70285651qkc.189.1558563605198;
        Wed, 22 May 2019 15:20:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b22sm14156670qtc.37.2019.05.22.15.20.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 15:20:05 -0700 (PDT)
Date:   Wed, 22 May 2019 15:20:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190522152001.436bed61@cakuba.netronome.com>
In-Reply-To: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 22:37:16 +0100, Edward Cree wrote:
> * removed RFC tags

Why?  There is still no upstream user for this (my previous 
objections of this being only partially correct aside).
