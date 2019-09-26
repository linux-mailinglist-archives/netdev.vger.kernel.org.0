Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF99BF66C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfIZQH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:07:58 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:38095 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZQH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:07:58 -0400
Received: by mail-pf1-f174.google.com with SMTP id h195so2107272pfe.5
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 09:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aH1eoftUCxbdSxiU7H/OByeIj0vTXN/xhqK+H4NjaaY=;
        b=Dknpog+lY07rctOi9Fei/M2ZpvjsSBEPgKZToBGKg4/40iGwZH7m/Ej1I59cVNN13K
         XZ5NtgP4NJGSNXmEYOTMW7BNsqFLaft5daJ9L6vJnR9zTct+Sp/pFhBa8X+t9rHMYXWS
         CkkVsUGc34faNdDgG/lYaPMWWV5sP77g44bpqWImp2pu/5TiBHSM2wdmTaMSuzGeBwyP
         pAXcvTrVR1W+L9E2EOaN0hE2jdnmcEpoZc0v8TDn90DHin6FxyTdsJZXphlt8983VaAX
         s5uC/TY8dUF+7wHMXZ7hxEpjzQJP5JAlFlhbggQ8AQcZxMbOZXFkrih/GlQ6n+olYcq4
         Ec3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aH1eoftUCxbdSxiU7H/OByeIj0vTXN/xhqK+H4NjaaY=;
        b=X06noBOrJwtk6LNXXJBKs5Q3WW7stq1YvwXk9uBVDHEDw1BewUSu+TRCx6JDuOwc1U
         m5SsNUU/IzaaZH6RNg+9aJJOrOaSDM/LIoWjYXNAs1RXT87eDdYHSnJTn/b3GzcNCdxG
         baraBAoJxJuB7thGgZ0nrCNMg/MV+TQRPui4T43UrdYwgV8njZsnyq1kNiDMxGL3JFzx
         Cw9EEWh9HoEISrLuNPT55kBjiIF6mQXbDWO92Rsf9EPnkfmfE+VcZJ9aCmq/Sf6nJo80
         UrYnkIdvDKG2zkTnyCAp/0LOSVWzvG6fxiehWB5zkmR3twpxgmi/FkPys9rgu5wyaBvO
         A/Jw==
X-Gm-Message-State: APjAAAWIHMftfldKfsngb4eoLe5MpWV+EdTbHHnsnjT7vCALd3l+hbgV
        ovkKrPmCwBAcq2kpN0pXijv/HJngRaM=
X-Google-Smtp-Source: APXvYqzv0J7SugCrf3SChDEDP5bwVPip3eHsT0SYi6nJd/fODBKdV8V0D9vMkflNMwj3ba1xltivQg==
X-Received: by 2002:a17:90a:183:: with SMTP id 3mr4337522pjc.63.1569514077673;
        Thu, 26 Sep 2019 09:07:57 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p68sm6438527pfp.9.2019.09.26.09.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 09:07:57 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:07:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Julien Fortin <julien@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2(-next) v2 1/1] ip: fix ip route show json
 output for multipath nexthops
Message-ID: <20190926090755.78b6234e@hermes.lan>
In-Reply-To: <20190926152934.9121-1-julien@cumulusnetworks.com>
References: <20190926152934.9121-1-julien@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Sep 2019 17:29:34 +0200
Julien Fortin <julien@cumulusnetworks.com> wrote:

> +			print_string(PRINT_ANY, "dev",
> +				     "%s", ll_index_to_name(nh->rtnh_ifindex))

you might want to use interface color for this?
