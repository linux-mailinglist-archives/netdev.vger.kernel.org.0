Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D159933F108
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhCQNTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhCQNTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:19:11 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E061C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 06:19:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id e19so2568023ejt.3
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 06:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JsNVdUgPCKJiK63zVm0GLi7R1rwnep17e3yztWQS8Oc=;
        b=cLH1vXK0ElYK+P8y4N1/kCm6GG23MSs+Qtio0pwLKmam4H/Zjmk63BUGfJOJjhtZvb
         6Wam+k1ItwS2tqORasfiiBtGsqUQvReH0KHB9sMhz9QT7yfGwzxK4J3UapnX0de6H+il
         mud+/5YKboOu0Pa8X5bTW25Cjs7Y7YUCXQybLQtMwoqZQKr9S2YcgCXMDynQj7NUo/WW
         mEVOO4Bh/4AObhnFiWP0aHiEzv8lamWKm49/Dsg1FkJlLMdZYK/a15t5kZMDaIRQBQMu
         Vb/L8UJjxYQdaArso14dLdYNDlwMUH21/7mB3FD5B1aglmYa7dD1t3JkwlizD6lAkzWv
         tbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JsNVdUgPCKJiK63zVm0GLi7R1rwnep17e3yztWQS8Oc=;
        b=TiZ+Ymz5Japyfcr2ubKGzS4K/iUBKVCxO8Vndmi+OpjYOoupvjJcx3p5pR0AXMv8jj
         2utxKjA3/+aHOerOvG0myCsjrRMt6yXAxBsTX1dt9uglSqQKAAopgiHX1AKjoPqTuh+4
         R+eK5YkF0ErVQR5GpmzXkUfkYwVInYTQjt4/WYZQvxux9hQSHngJ85ZFCyDdv+giCw5e
         QYV+qm3HfvEXiOAX/8dKW++DTSxVmFf/rgakM7F2TUh2YI6XMqzRm3Ew7CMrRgcxERDu
         VygTxLLFE1Y/q7wtQmAjTpcqqnWZPRDblSo9M6Tccf1Do9VhW653WWT6Whah1mirGmfz
         YGNw==
X-Gm-Message-State: AOAM530THsW0v9qVTRqNoFSg5Y1TyDr7Ofadrp+UNoDT0m13aGFMgI0A
        CjW4AsZOC2COFim3bxeE0QAz8X466M2ZHSRI3DQ=
X-Google-Smtp-Source: ABdhPJx+uLf0Ll3fXoZj6KYBhVK3Z5NG7Lt1qgdCCIeCsDS3ej3Kd8hJqX9bDYXRbat55ZWJNDzbYr6HSFQv632Fj2A=
X-Received: by 2002:a17:907:119b:: with SMTP id uz27mr34728201ejb.464.1615987138855;
 Wed, 17 Mar 2021 06:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210313063535.38608-1-ishaangandhi@gmail.com>
 <CA+FuTSezOVa2rfvgFx7gfYXsxg-6k0QUAe32o_MSUJ0b_-R3zw@mail.gmail.com> <849E5C80-9864-4A96-9445-499BFC3FF83F@gmail.com>
In-Reply-To: <849E5C80-9864-4A96-9445-499BFC3FF83F@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 17 Mar 2021 09:18:23 -0400
Message-ID: <CAF=yD-KS-F_=VytzF2WdNeQ7K7=nezoB3bWdgkUpEdfDM_weDg@mail.gmail.com>
Subject: Re: [PATCH v2] icmp: support rfc5837
To:     Ishaan Gandhi <ishaangandhi@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Ron Bonica <rbonica@juniper.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +       if (ip_version != 4 && ip_version != 6) {
> +               pr_debug("ip_version must be 4 or 6\n");
> +               return;
> +       }
>
>
> always true
>
>
> I should remove this check, then?
>
> What is the standard way to differentiate IPV4 vs v6 paths in network code?
> Is there an enum with IPV4 and IPV6 options that might be used instead?

My point was that there is no need to check against an unexpected input,
as this patch introduces the only two callers. The use of ip_version itself
is fine.

I did consider suggesting splitting into separate icmp and icmp6 handlers,
but most code is shared.

> Thanks,
> Ishaan

Please use plain text when responding. Your message did not arrive on the list.
