Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42F837FCC
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbfFFVo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:44:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40136 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFFVo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:44:57 -0400
Received: by mail-pg1-f193.google.com with SMTP id d30so2082909pgm.7
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R4zB8Fv1vR3++3bwLf5L5OV5X/RFWvUzMvJeHhBQwic=;
        b=NUKJYIA0a+zgkePMUu6rCDzsBJ2rfVv44vXjMGiNalHCruoexCaWkJDECNXS4mPNsw
         MCvXDNpqroIP83QQN1m7SktaWGbuBzRmiitA7y0liVXQH3dBLR5k4XoQzhZ2d5AHoVvr
         dAlgYSgGubj6RkSi1sWPLSJfqNQspbrCQO/XZz+1aosKVlwpvPQipLmD3tk+GGJTXmjK
         dl6ITiKiE3sWaoTwTYZxgFFswgHmkRI7jX3IOpvMwRbR2ZQRZhXbnV9MZFOyEw1P+hSp
         NR+aAYdj1d3OQBlgcRwwXmt2V1ebbsJHBAQHzSEqu5n1Wh/lO34RpsKgeyM0LP8yGecB
         jB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R4zB8Fv1vR3++3bwLf5L5OV5X/RFWvUzMvJeHhBQwic=;
        b=YsB33AqnZVIjzKe7Hm/SUv3yTPVGW9y1f4JDI6ojkS+W7VsWe7fV/GB6rY+hhpX9t4
         H9bu32oOnIl/1kGxb3jpvdWiF1dhfCR+wVHBtKzSn3LevAoSd69HJopaS9b/NcOKAUOT
         YhSkhChmrj2i1DdMiq82NJYJEcmZj5qMz02Vav2bxZG40nZiRrU+DCkDksWRHa/cDHEw
         Q+pob/v63j3AGJ5H+CJ0FppOtoZ0iqfJQDjXOzU9vjyTkUlJJI2Zyn/tI7eNdLqltTrP
         QaasMHXZzSDzHgD/5nWJL2n2kjs2CpG/rgvnnDck6aj28uDPo93AAEF4iNrEAAVw14i+
         +FJQ==
X-Gm-Message-State: APjAAAUA8p20Jyli3QKuNCokO/nQ0jQOnTfwX8y6Cj0qif0Uy5tatjCT
        hUhDyfX3AgODO3WWbY/Mn0rGMA==
X-Google-Smtp-Source: APXvYqxqLMZLObI4g6zZW9VcKnr4CipDHSCKx/0EDUKhVbKy3JsyNqsjvs46oHuRWkPQM9Vx72Yhyg==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr1956387pjz.140.1559857497147;
        Thu, 06 Jun 2019 14:44:57 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 137sm102003pfz.116.2019.06.06.14.44.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 14:44:57 -0700 (PDT)
Date:   Thu, 6 Jun 2019 14:44:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2 1/1] tc: Fix binding of gact action by index.
Message-ID: <20190606144455.6180db2b@hermes.lan>
In-Reply-To: <1559856729-32376-1-git-send-email-mrv@mojatatu.com>
References: <1559856729-32376-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 17:32:09 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> The following operation fails:
> % sudo tc actions add action pipe index 1
> % sudo tc filter add dev lo parent ffff: \
>        protocol ip pref 10 u32 match ip src 127.0.0.2 \
>        flowid 1:10 action gact index 1
> 
> Bad action type index
> Usage: ... gact <ACTION> [RAND] [INDEX]
> Where:  ACTION := reclassify | drop | continue | pass | pipe |
>                   goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
>         RAND := random <RANDTYPE> <ACTION> <VAL>
>         RANDTYPE := netrand | determ
>         VAL : = value not exceeding 10000
>         JUMP_COUNT := Absolute jump from start of action list
>         INDEX := index value used
> 
> However, passing a control action of gact rule during filter binding works:
> 
> % sudo tc filter add dev lo parent ffff: \
>        protocol ip pref 10 u32 match ip src 127.0.0.2 \
>        flowid 1:10 action gact pipe index 1
> 
> Binding by reference, i.e. by index, has to consistently work with
> any tc action.
> 
> Since tc is sensitive to the order of keywords passed on the command line,
> we can teach gact to skip parsing arguments as soon as it sees 'gact'
> followed by 'index' keyword. 
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied
