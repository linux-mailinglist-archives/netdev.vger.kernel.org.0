Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477C3E7840
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391086AbfJ1STI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:19:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33277 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJ1STI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:19:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id s1so10969059wro.0
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 11:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LtkWh5ANBgNqobXnHOEpoIBhsjc5qh0/GvIr+uBPE2k=;
        b=jjf6kqtM1nKFxCWFvZ8SPbGqrzgDfBMvujxRqR+EtFBLvyHrzWZTl4u3vqJ7glFnXI
         yLZ2gzYZvhoqCALxrRsAB1CQnbhU5h1qjtIyB3L37mdnMjHN8sariAQpbDo4YlzjgBIc
         prl7f2EnXRMIfqRMPgUDQo1tUL9nBSAZKFfFE14wBDGBSaEznZWos/c/3JhAvgY0PV/M
         Io558AkynBBwEvhtp5m6TWGhs/wnqtITZfAACiqOAk1RatOL8WkRF8dGDHOPRIRa9GEi
         0MAMeW1qvhd49gUR1m4kRNeojh0HyVrlmx5CEuxGOkxryyK0HQVsqd7KBtsqYXJcgCDX
         nIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LtkWh5ANBgNqobXnHOEpoIBhsjc5qh0/GvIr+uBPE2k=;
        b=tiB0ZBGJDI8aJ8g0hWjjzpLgUMuNQyVdM4fikHymuFVhZMMR7yQE7ltNfAd7D/8rXt
         CcsiL8WbBFW492Wlpd1fNSDew0tdW8rpX5YFi6X7vX8Sgtm/HweE1dXlvCThIFGqV5C6
         kIvpVcoD4atPqYoqocBvKPQxexI7PhJWxgLmEX3E3Ciq5QSUJqBkpsjpG6sFY8dXKtS/
         G9RHvAHEUpOg/W9Oa4JFGu576YTK2Ik/HZUjLkionxJJl5H9Hdi4zdp8vfUzQEppnMJa
         lntgkp5pDKPKW0DRkn5l1Wdm4jK/Eh775siR85M3zhKR+KQISJsim7AwmCMrxSIST7HE
         YKuw==
X-Gm-Message-State: APjAAAWUDs6pjJ0boF1cflKKdRjo4Lwa82v2OBlBk/wa51k/ZUl+tjU9
        omZfHj0V6t6NawG8Aom6zPHGrw==
X-Google-Smtp-Source: APXvYqyWmwhNNFKTXh/jZuAzPtstHg65hqAW9GlagHK4rmmvUVhT9kvViH1lSj436f4vL0+0il2kvw==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr16605169wrw.176.1572286745725;
        Mon, 28 Oct 2019 11:19:05 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id f204sm350862wmf.32.2019.10.28.11.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 11:19:05 -0700 (PDT)
Date:   Mon, 28 Oct 2019 19:19:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v5 0/3] ip: add support for alternative
 names
Message-ID: <20191028181904.GB16772@nanopsycho>
References: <20191024102052.4118-1-jiri@resnulli.us>
 <c8201b72-90c4-d8e6-65b9-b7f7ed55f0f5@gmail.com>
 <20191028073800.GC2193@nanopsycho>
 <057f3a0d-b4ae-8810-28dc-a92866f976ae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <057f3a0d-b4ae-8810-28dc-a92866f976ae@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 28, 2019 at 03:49:57PM CET, dsahern@gmail.com wrote:
>On 10/28/19 1:38 AM, Jiri Pirko wrote:
>> Did you by any chance forget to apply the last patch?
>
>apparently so. With the 3rd patch it worked fine.
>
>Applied all 3 to iproute2-next.

Great. Thanks!
