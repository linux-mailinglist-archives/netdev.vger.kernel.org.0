Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D8B24C35F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgHTQcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728466AbgHTQcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:32:11 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B814C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:32:11 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w9so1616295qts.6
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WvWETTcbIkC0B+KDTeQ93Gl7vMKeNszWHyAKtvflCJE=;
        b=CsXruPOuWfHEwpw4qsk2NiFdgZX0aMp7j6s8O6Mot/RX/S/xgJvVvtc7/jNgOZFWCJ
         8nFyQeSkYwbsNADpaYyhCrPad/urQ9hZwygaLCSiMG4m1qP0gqgcu/cA0g5XikGQmdaJ
         LI6/ip7R8mj3FXf33HCw8KW9goQ2m2/qMK1OYf3uY5X+Opbf+06FwTwvQlO/sOYmKPRP
         jynFfqvhD13jv8Vy241njIb8SLLqEShrmWWL53AtUyEn+sER9LUJ4HBKlKcpero0bQ8U
         1bM6BE9FQauBqxOO6IzxVpPmyTOaeWdHfByIW0aZHeTVi4UJo7u+kiEgtt/J+Ap9nS/d
         sd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WvWETTcbIkC0B+KDTeQ93Gl7vMKeNszWHyAKtvflCJE=;
        b=JZv+NJsbYcp6P0krZdpRu5TQTQsNm7CfzqCV18Hii92li+9MmfXiXgoXBMcQT61ljv
         fKCRfqYL9IjepkqvnqLPThRnyhPorGKvVj+i5apjroNYKR6gBK2XyjMD8g2bWtW3+9ZX
         dR3W2dlZ2ydR8VbxIKuFpBzq4rDMnp4VPExOT/V7cNwjuOm/AaC+AHXETjr+uHioaKaJ
         7X76daM85+LoX7YT4tyNtUTXA7EDTGj9zuWpRkXK0j3lb8tAwqS8Hvens63tZW+RbhQP
         Kw/7omqfM9vBezXSJRtpDNJeS54mQqXyudauTpkMN3uK2X3UZ2cBmO5QJpenImBDLDM5
         k2+w==
X-Gm-Message-State: AOAM531OFaxyIR1/Hb3PqPFKQpoHuVKQyOlj0RWvVzLXl54jtbfX5n/3
        Y5Wt3wAfeZPUY4ZixYXW0+92EhRE1MtuiQ==
X-Google-Smtp-Source: ABdhPJxCkE7oY8a51HJPM9nEi5U25zwbvzkjFwfH1uEFhZjKSlmIyeGODw5YVyWlhL7EcqR2TimPBg==
X-Received: by 2002:ac8:44d5:: with SMTP id b21mr3527889qto.261.1597941128825;
        Thu, 20 Aug 2020 09:32:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4452:db16:7f2f:e7bf? ([2601:282:803:7700:4452:db16:7f2f:e7bf])
        by smtp.googlemail.com with ESMTPSA id k48sm3767794qtk.44.2020.08.20.09.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 09:32:08 -0700 (PDT)
Subject: Re: tc filter by source port and destination port strange offset
To:     Denis Gubin <denis.gubin@gmail.com>, netdev@vger.kernel.org
References: <CAE_-sdmwbA-Otz1a__tQrTB7jT53b7j0PB2q7xPV6MYLrY5YGg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8dc122b6-43e3-46a2-5033-1df3ce4adb7c@gmail.com>
Date:   Thu, 20 Aug 2020 10:32:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAE_-sdmwbA-Otz1a__tQrTB7jT53b7j0PB2q7xPV6MYLrY5YGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 3:30 PM, Denis Gubin wrote:
> tc -p filter show dev ens5 parent ffff:

pretty mode is for use with json (-j), and there are shortcomings to the
json support in tc.
