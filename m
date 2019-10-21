Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D04DF58A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbfJUTCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:02:11 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:37444 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfJUTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:02:11 -0400
Received: by mail-pl1-f177.google.com with SMTP id u20so7081851plq.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=30xiBymQK9box84qAD8CQTg6IwKYlclhkZTAMfa2Cyw=;
        b=jbEVovKKF/wwh1xFcgFFtCLPvMAQwgBl56FTKr2aNj7TdCBYsbjgMkpNc5PAB1K9hN
         CjGDdfkZttZOjS9q52CK3YVN9z4dF5r/ot4yrYjzgcvZ31VoXb2GOL6Pk+0kSBaK38qN
         FvFb4bJ9ADe33SeupEw+Ll7wkxUiYMWnz+9tEOUDthQEInnqCGokcF/Y5UekVag7NP63
         FmjSoQaITgWT3VG9rxWjJta/+0EM/3QvQucALyyn3pKbfScRKJTPJdETPjhCc67mW1cR
         Z8wFyGyPl6LsuMHSDWSe+Cp72+FCeVsV5W5HguqXcODElAxhqaGBhspCjP0q+2GS24Om
         MZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=30xiBymQK9box84qAD8CQTg6IwKYlclhkZTAMfa2Cyw=;
        b=dO4mJ7Tu9A/xMRGSYa/BzdfP9mWFoAZ1clcRyS9Onc0CVzWnt6AjmJc4y45LX0Omsc
         Bqsq86x/5guHnMNBmQ5bmeXbkuMuGflQ4i3XmE3A2JIyaciOB1BwgApNpnXTeq7ztINH
         8oxdMSlze0NE3NehXBbyKuAZX7ptHItAtJoTGb5gfn6HyTEXFJqh88crFuVk4K+PSv3t
         zxhtSmGqZGeuc/oflXugzJq9+ZBuyMECXzCe1KAIDR8vnVum1AhXEnxs5Qa+SfSXu1oo
         L/Ihuq7JJsMfmbTZZS63CNOjWXjdFRK+GzX+xnPhFixeCi8KwFNv8Vi97+nfyPlP7mwL
         D31g==
X-Gm-Message-State: APjAAAWRzm/aj9mTu0HuQluB/Rh0mU6DXVP2m8fkeV9DFUz8jdVrd5tI
        lfWwDgDilmzffrQ0pNGxiEs=
X-Google-Smtp-Source: APXvYqxaDybZ/wksiGGlc8zsJq7VkuEQwGZcjq4ddUPN4O/PYY0ZjX85kGjS4jaOx91B93O598PifA==
X-Received: by 2002:a17:902:7483:: with SMTP id h3mr314167pll.270.1571684530222;
        Mon, 21 Oct 2019 12:02:10 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id p9sm16220536pfn.115.2019.10.21.12.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 12:02:09 -0700 (PDT)
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     William Dauchy <wdauchy@gmail.com>, Jason Baron <jbaron@akamai.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        NETDEV <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CAJ75kXa0EcXtn6xBNCr56A_Auzm9NOtPGhXUTGvSARKgfOjTcw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b781b46f-2682-6f59-1f61-312135b0924c@gmail.com>
Date:   Mon, 21 Oct 2019 12:02:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJ75kXa0EcXtn6xBNCr56A_Auzm9NOtPGhXUTGvSARKgfOjTcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/19 11:49 AM, William Dauchy wrote:
 
> I'm curious what would be the arguments compared to creating a new
> getsockopt() to fetch this data?

Reporting tsval/tsecr values were not well defined and seemed quite experimental to me.

TCP fastopen would use 2 unused bits, not real extra cost here.

This is persistent information after the connect(), while your tsval/tsecr report
seems quite dynamic stuff can be stale as soon as the info is fetched from the kernel.
