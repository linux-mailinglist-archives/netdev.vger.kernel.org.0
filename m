Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA112ACD2A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgKJEAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387477AbgKJD4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:56:03 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95625C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 19:56:03 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id t13so10494963ilp.2
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 19:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Z4Gev3At3/+7WYsIRbgs7lJDvm//A/cHTMAu+zMHgAg=;
        b=MdsPYgNzb08Fl6YqOpRB7fIbd66l+aZNDhpLwPVEPb+Y0Lmf1jiFha1FcLLN7c3rdi
         BDNLY4QbLFZAMo/X9tU4wCQhmb/mMZ5HWMbXKTifkfgag4/xUwn+70c3vGa13WapV4wg
         xovzdvz/Z3vWwrlYVvpRqaN7daMaQZ87lXUNzl2dl5hu38+1seWHvWDj/1PvzHXhpNOI
         NljWNKG+WwSBx4gP1dZKQdJo4cDGXL6qf0ELqDhlXAI+WCx+G9BpsbqO2bez/nHqlOGV
         gZ8DpUQ5gIMzib7hbCc4JtjhI22UeqJ6a06v2rUSrp+hnbomnowON02jSo6ybieKemV0
         Nukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z4Gev3At3/+7WYsIRbgs7lJDvm//A/cHTMAu+zMHgAg=;
        b=qb6hWSiYdofvCzPZK0BGLDo1T62hUloRRKqIFMjAKUPWrLHN4XH0OmzVON+CUF3EDO
         Qhx5HF9jn1hMRP0EfCRJ1E5YGYI+qXieIgQntMbLVTTx6ON/4Ut5839ClpubzKnbaMU7
         VZu2vSeAAM7tc1JgUl/mFjA72VOM1zfBIUhIiplVDdXI2zWVrXyQsZ8Xl64I3cclp94Q
         drt95Id0Vb1L76+cO5WKAy+8aM/+O0+F5dRrM4CkaTDMLUs2spYwvTRm8980vzhTDp/8
         wZykFukzYKJBzDmBNhhn6SgJ5yxOFuKQ3dqlKAkkhbCrZF0M5Nzu7CsQ8Dzqm+oDzb3e
         Y3ZQ==
X-Gm-Message-State: AOAM530pSEkJ1voidkYi4UdCg9Dw9VfVSK0PkPgAf/i+saC3Lx42gGA3
        fXH0OHreK4vha3YJre13DSGf9m0TiIY=
X-Google-Smtp-Source: ABdhPJxseRk1o7Z43dfXvnJwagWnH6aVYyMaD81IA4Sk0wEXL3t0jWXUoOSWoqp+Tqya63wo1niC2A==
X-Received: by 2002:a92:ba97:: with SMTP id t23mr8649122ill.208.1604980562846;
        Mon, 09 Nov 2020 19:56:02 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id u15sm8130723iln.81.2020.11.09.19.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 19:56:02 -0800 (PST)
Subject: Re: [PATCH net V2] Exempt multicast addresses from five-second
 neighbor lifetime
To:     Jeff Dike <jdike@akamai.com>, netdev@vger.kernel.org
References: <20201109025052.23280-1-jdike@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <50c52b3b-9bf3-6666-df4f-a30cbffd208f@gmail.com>
Date:   Mon, 9 Nov 2020 20:55:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201109025052.23280-1-jdike@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in addition to Jakub's comments ...

On 11/8/20 7:50 PM, Jeff Dike wrote:
> @@ -1706,6 +1708,11 @@ static void pndisc_redo(struct sk_buff *skb)
>  	kfree_skb(skb);
>  }
>  
> +static int ndisc_is_multicast(const void *pkey)
> +{
> +	return (((struct in6_addr *)pkey)->in6_u.u6_addr8[0] & 0xf0) == 0xf0;

ipv6_addr_type() and IPV6_ADDR_MULTICAST is the better way to code this.



> +}
> +
>  static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
>  {
>  	struct inet6_dev *idev = __in6_dev_get(skb->dev);
> 

