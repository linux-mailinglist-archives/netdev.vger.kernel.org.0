Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4CE28B8EF
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgJLN4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389626AbgJLNpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:45:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC05C0613D5;
        Mon, 12 Oct 2020 06:45:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m17so17730365ioo.1;
        Mon, 12 Oct 2020 06:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x23MZBbevFdfsPCF3UovTBxz8CSNW7Av4ebu9sTDXl4=;
        b=N8e1QFkrPWUuBXpcX0Zp4M7Tm+7rSSEJ59YN8UExLbwprnxYZUTCE7eAvbBQNRddXi
         z/bYhHqRSyV210JeTdgFevguIXMgbDAfqi0RkiwvNo0mMM1Uszc4KP7mchLEIm+5xOi9
         vYNLNsMKAePOMP6mOnzh1013N4Hen/o7pL3uXTkSuTfwUHxcL9oXjXMNEIGnoxywpCuV
         wvRspS3hMANFvQPbs3CCnVp93ZiZs285vLXwze/vOyVbztQfcuInag1Jz+dJxcZ3KejI
         ZXYdCB04Tu8wLW9F3gD77xahYaoaC8UcKY5o/VhnzHPbHRoudNSlYv0agpNOrZxqeiRc
         D56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x23MZBbevFdfsPCF3UovTBxz8CSNW7Av4ebu9sTDXl4=;
        b=bfTRrHxp2Z8B0Gtsz9s9SyXgNgJ3FDCAnXTB5mbWkOCSGRQkzZ7GWosfbc7emKmsNm
         /eNj8Fc3oujs3BRHFUR0Ghka+ah+f54TyL7H3i87/hO2ZlmQrpT5mGmUqxa5WKF8G7YM
         BYxDwI+vqIjNaGbx8Pf3A4NUGSOxJWqP6jsdYNe0feU61E9KQ6EwWmZ3e1vHG8sYiCUr
         FzpjDgSM6mC7dK04JX01pRrtVXHrR9fVu7JUbOMNmFHo3eyPO5iFlHqy7IQBAWXjGJfQ
         v9T6fK+X1xMIa/1xu6CLzKA5zB+udx2WMsD8StJ7eIzqKhnVUz/Lrfkw1QukPiwURD0P
         0ygg==
X-Gm-Message-State: AOAM530cLtnpUFG3LEdoPyystfpiWk+gWn6MNZe97tIQ2mzYwLDw1Guw
        yge1SYBOrnWxnOu7JNXXpigAF3sbaXw=
X-Google-Smtp-Source: ABdhPJwuac1BqXhMOmQWJRdzZxUob0VrfqcUnvM38G4D049TG7XYV+ddM32nGMDSdZ/HPfoZ2DyxMQ==
X-Received: by 2002:a5e:9913:: with SMTP id t19mr7015162ioj.95.1602510316646;
        Mon, 12 Oct 2020 06:45:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id m2sm7307155ion.44.2020.10.12.06.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 06:45:15 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Michael Jeanson <mjeanson@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
 <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com>
 <19cf586d-4c4e-e18c-cd9e-3fde3717a9e1@gmail.com>
 <2056270363.16428.1602507463959.JavaMail.zimbra@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74f254cb-b274-48f7-6271-4056f531f9fa@gmail.com>
Date:   Mon, 12 Oct 2020 07:45:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <2056270363.16428.1602507463959.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 5:57 AM, Mathieu Desnoyers wrote:
> OK, do you want to pick up the RFC patch series, or should I re-send it
> without RFC tag ?

you need to re-send for Dave or Jakub to pick them up via patchworks
