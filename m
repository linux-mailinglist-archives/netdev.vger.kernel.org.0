Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4758C1F919
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfEORGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:06:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42600 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfEORGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:06:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id 145so81318pgg.9
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/OpXwq79Evc4sZPZsH7EP6mB6R7H40Pg4ObnVmwED1Y=;
        b=BCsDd0gwJ2R9zgCKXphnkmwcLOc+F3oC/qlyy0hPLKDQ+nZc9dxJDlV5jCN/mxQUTY
         TiS2qP0nJT2+gEZzgxYlSGRaz13AgCIsHXO+Fm3tuPk2rwUwzd6gFceGSWUq6omsIQoF
         v0Hni5yqDtfUX/f8E1GBHGynxj728J11Yz6io=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/OpXwq79Evc4sZPZsH7EP6mB6R7H40Pg4ObnVmwED1Y=;
        b=pmK1YZupSrsaJOucLKhHkX0hgzyPG0czfDMm3xpXgpHzewLVOf3N5hryubvdOn3IXi
         7dwYqNB0us0t8mvCaxCoVuV8Uujl8GjmCryVl6iIgNgutne+A5pXT/uBAu/NzrvQyPlz
         KmmGBBUQ2/soU2GbVpL/5L0Lx2KKBiHdbaO2rDmeNgUOOI6crqbRdqNdKd84JRUyU4sz
         /GvLITpGOxhN3doYJ5JMUd4sz5IkUnARKzB1UjuW6FYmv+AC+J/3FrlcL/fAnIutIeLK
         5Bv+IqwuJR4QTCMBAPcy7BN+DWrIVMUIdC9ZmqxSzf60Cqs1Mx3UlWqEf+vNTEK5tI3b
         +y3w==
X-Gm-Message-State: APjAAAUBhmggsdjSorfNfd+6Vm3l9MnZPh0BH3du25rK4idNp94Z60yo
        Sk0R0Xf5E/IRIJNF22jpJEtcqsCvsRU=
X-Google-Smtp-Source: APXvYqwXXWl1fEnyKxxNDYyXc7XBFaa07x9vjWp5eNzPe4i6FNK5Iga6srIqWZfEA3QJR+FitDiYaQ==
X-Received: by 2002:a63:4342:: with SMTP id q63mr44719536pga.435.1557939971271;
        Wed, 15 May 2019 10:06:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b63sm5310681pfj.54.2019.05.15.10.06.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 10:06:10 -0700 (PDT)
Date:   Wed, 15 May 2019 10:06:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     mcgrof@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ebiederm@xmission.com,
        pbonzini@redhat.com, viro@zeniv.linux.org.uk, adobriyan@gmail.com,
        mingfangsen@huawei.com, wangxiaogang3@huawei.com,
        "Zhoukang (A)" <zhoukang7@huawei.com>, netdev@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH next] sysctl: add proc_dointvec_jiffies_minmax to limit
 the min/max write value
Message-ID: <201905150945.C9D1F811F@keescook>
References: <032e024f-2b1b-a980-1b53-d903bc8db297@huawei.com>
 <3e421384-a9cb-e534-3370-953c56883516@huawei.com>
 <d5138655-41a8-0177-ae0d-c4674112bf56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5138655-41a8-0177-ae0d-c4674112bf56@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 10:53:55PM +0800, Zhiqiang Liu wrote:
> Friendly ping...
> 
> 在 2019/4/24 12:04, Zhiqiang Liu 写道:
> > 
> > Friendly ping...

Hi!

(Please include akpm on CC for next versions of this, as he's likely
the person to take this patch.)

> > 
> >> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> >>
> >> In proc_dointvec_jiffies func, the write value is only checked
> >> whether it is larger than INT_MAX. If the write value is less
> >> than zero, it can also be successfully writen in the data.

This appears to be "be design", but I see many "unsigned int" users
that might be tricked into giant values... (for example, see
net/netfilter/nf_conntrack_standalone.c)

Should proc_dointvec_jiffies() just be fixed to disallow negative values
entirely? Looking at the implementation, it seems to be very intentional
about accepting negative values.

However, when I looked through a handful of proc_dointvec_jiffies()
users, it looks like they're all expecting a positive value. Many in the
networking subsystem are, in fact, writing to unsigned long variables,
as I mentioned.

Are there real-world cases of wanting to set a negative jiffie value
via proc_dointvec_jiffies()?

> >>
> >> However, in some scenarios, users would adopt the data to
> >> set timers or check whether time is expired. Generally, the data
> >> will be cast to an unsigned type variable, then the negative data
> >> becomes a very large unsigned value, which leads to long waits
> >> or other unpredictable problems.
> >>
> >> Here, we add a new func, proc_dointvec_jiffies_minmax, to limit the
> >> min/max write value, which is similar to the proc_dointvec_minmax func.
> >>
> >> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> >> Reported-by: Qiang Ning <ningqiang1@huawei.com>
> >> Reviewed-by: Jie Liu <liujie165@huawei.com>

If proc_dointvec_jiffies() can't just be fixed, where will the new
function get used? It seems all the "unsigned int" users could benefit.

-- 
Kees Cook
