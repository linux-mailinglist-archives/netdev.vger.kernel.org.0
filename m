Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5161C1919D2
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgCXT0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:26:40 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:38448 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCXT0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:26:40 -0400
Received: by mail-pf1-f179.google.com with SMTP id z25so5483300pfa.5
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 12:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/hbSVQDwvzQMVSvGUhbwAm3HTidVVqo8CbOQlN9cmr0=;
        b=hsn8pm4QRaq1eaCn8lemGxnYJ2VRe140HpSbSIWcn5uleug3T2Xq3nWuGt1l00QSMi
         YeKwnLoiyDZB8OTFXbWwuP6j/vyzpUqhO1Y6BKhZCKO36QIkH9HmNC751vEVbqZQARZ1
         loXtYUworqBjRwn6zep9GKHgjbEHzZBx6T6ew83UM4jWTky/IAo5POz4KvZBaVw4obtm
         tPRj/frYneUEk1Sxx7atgxSg0XT/AmV3kTLOrYjEv1HNeCR5jCqPFxUuq/YuW9n58XIu
         yYxFeOFcKU5bKDKqi7pxXsRkmaf7s7DWfSlz+jF9vDxMb6GyaxZ6TO02CUNE4GKzwGVx
         SWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/hbSVQDwvzQMVSvGUhbwAm3HTidVVqo8CbOQlN9cmr0=;
        b=RGDyG/i5wb4FKCI6UXljutYE8J8dd4ux335DnPpA4D8i6MYnW59vTN8HiFFm5P4Y0t
         XYiAGG0nqi1BQ0Iw5dghq3ZNx0iF0LYIUmsmG433J99ZFBumskqH9M85iECAleOtHOTD
         w9bRyBb7orrw8SnU0gKbZapAgH5EsQnvlGStljRWbCUHHWeKFZZDW0GZX4wK6I8T/C7M
         4wspUQZzb+k5wjRuvmzwekcyP1JA6dyxDmqjsE+qLBLWr2PTx/Jw2PlfRqDoSgyuEVa/
         41ai1XX6uvzR/Qo8Hp3EE6p2lec3vieEyedKsZjkZ7MHB5bSfXNfZUiZME9Qzpo3iik+
         +lqw==
X-Gm-Message-State: ANhLgQ20BdgrzBZSUMWE3uzyILjA9HtaQhB0BqahhKnyZbBq9tFY9J60
        +aPrABp3NeaD3KPLQGIwGBo=
X-Google-Smtp-Source: ADFU+vvU6YOYg+ZyhU/KvkOb6oiffxmPnJgW++3DUPAI5rlgG0slQlqmOpqEitoVnzipQaygWvkywA==
X-Received: by 2002:aa7:988f:: with SMTP id r15mr31835799pfl.252.1585077997358;
        Tue, 24 Mar 2020 12:26:37 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v25sm12338809pgl.55.2020.03.24.12.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 12:26:36 -0700 (PDT)
Subject: Re: [RFC] Packet pacing (offload) for flow-aggregates and forwarding
 use-cases
To:     Yossi Kuperman <yossiku@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Rony Efraim <ronye@mellanox.com>
References: <d3d764d5-8eb6-59f9-cd3b-815de0258dbc@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4d16c8e8-31d2-e3a4-2ff9-de0c9dc12d2e@gmail.com>
Date:   Tue, 24 Mar 2020 12:26:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d3d764d5-8eb6-59f9-cd3b-815de0258dbc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/20 12:05 PM, Yossi Kuperman wrote:
> Hello,
> 
>  
> 
> We would like to support a forwarding use-case in which flows are classified and paced
> 
> according to the selected class. For example, a packet arrives at the ingress hook of interface
> 
> eth0,  performing a sequence of filters and being redirected to interface eth1. Pacing takes
> 
> place at the egress qdisc of eth1.
> 
>  
> 
> FQ queuing discipline is classless and cannot provide such functionality. Each flow is
> 
> paced independently, and different pacing is only configurable via a socket-option—less
> 
> suitable for forwarding  use-case.
> 
>  
> 
> It is worth noting that although this functionality might be implemented by stacking multiple
> 
> queuing disciplines, it will be very difficult to offload to hardware.
> 
>  
> 
> We propose introducing yet another classful qdisc, where the user can specify in advance the
> 
> desired classes (i.e. pacing) and provide filters to classify flows accordingly. Similar to other
> 
> qdiscs, if skb->priority is already set, we can skip the classification; useful for forwarding
> 
> use-case, as the user can set the priority field in ingress. Works nicely with OVS/TC.
> 
>  
> 
> Any thoughts please?
> 

Why not using HTB for this typical use case ?
