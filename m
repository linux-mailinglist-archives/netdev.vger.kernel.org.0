Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3DE1C4CB1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEEDgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:36:13 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF7DC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:36:12 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s9so1014923qkm.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ile9g4rkgP6HPtxlqOMvaYx9tsJu6qeR4NE9z5cz4Kc=;
        b=T3P7C5tJZS8w68qEY+Lm0KB1fb1lfP0EvAEovF2ep79giytzILGhla/vCw+Pb8HnwF
         zzvEVImEytgC53YrpFq1Aw+u1s/6dJvIl3AADGE9c/+i4dcoS0ASW/TjsiKBzElssA6/
         A760tYIcK33n5pL3+mW++8eMgPoi98ocpLBzLEXyvK1y9MQ2LCAz5TEmVhsi39IytiGa
         n20E+NIcEMZX75c1DQgwG3NDcjPpwt+ptYCpXZW2fTENQGbaU7uXRBNod0tHJgp7yiDm
         oiDuKA6GOGrVrgdiiHgvdEfXu1wQHXZuAqtKoc6cL1N9CsCwPjamXkZG7b2G3AY8Xc3F
         RDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ile9g4rkgP6HPtxlqOMvaYx9tsJu6qeR4NE9z5cz4Kc=;
        b=cZFb2bBl6aEtoVk0EsJ/MIMgEVD45kencIWaR0aXYv5xaczsGOCJsdEERNGV3HZz1h
         fekSy9tULBOyPBWihdhLUjV1s7Uqb67fVRjRij2wYijdyR7RGaqmP76R6iu1npLk+vIw
         x4zebYDrxce6urzzZ7L4rqtT2lKQfLWe51gK1L8A8v+cBu0vQXB0Le3ARju9AdP1Vfnf
         tllk8fZtVqqjNcfaOGFNgCDQ/aFrdb1vE9pcQ9RLcOdo+he/kV1qCpsJm+dDmImbk/+G
         9c5kiVPHB2e797KhZcD1W40do2bAnzKocxY9xhO5U30pc1y41P2sJxcFNoa0icIOkSMM
         mJPA==
X-Gm-Message-State: AGi0PuZv+/R8jyyZFwXFSJ9HLCmiCfMQbr11buvfzXyIrmAKujvudY02
        oFzD6GbXq7llOFfcy60OHQ8=
X-Google-Smtp-Source: APiQypJZD3PEP3l8wy2BjsQ7qX4McIAwpJxam05XHr8p8xXya0EV3rrU8ciJ2IlJNJ1Y0rupZ+ULOA==
X-Received: by 2002:a05:620a:219a:: with SMTP id g26mr1608112qka.228.1588649771161;
        Mon, 04 May 2020 20:36:11 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4fe:5250:d314:f77b? ([2601:282:803:7700:4fe:5250:d314:f77b])
        by smtp.googlemail.com with ESMTPSA id j6sm75864qkl.87.2020.05.04.20.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:36:10 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/5] vxlan: ecmp support for mac fdb entries
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
 <1588631301-21564-3-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3af21621-2868-612e-f8c5-649f1f4cb602@gmail.com>
Date:   Mon, 4 May 2020 21:36:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588631301-21564-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 4:28 PM, Roopa Prabhu wrote:
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index cd144e3..eefcda8 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -29,6 +29,7 @@ enum {
>  	NDA_LINK_NETNSID,
>  	NDA_SRC_VNI,
>  	NDA_PROTOCOL,  /* Originator of entry */
> +	NDA_NH_ID,
>  	__NDA_MAX
>  };

those attributes are shared by neighbor and bridge code for example.

nda_policy should reject it, and a new attribute provides a means for
starting strict checking (add NDA_UNSPEC with .strict_start_type =
NDA_NH_ID).

Similar for the fdb code in rtnetlink.c. Shame AF_BRIDGE parsing does
not have a policy attribute.
