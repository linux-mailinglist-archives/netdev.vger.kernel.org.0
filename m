Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289F1248D78
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgHRRtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:49:04 -0400
Received: from mailsec112.isp.belgacom.be ([195.238.20.108]:54974 "EHLO
        mailsec112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgHRRtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 13:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skynet.be; i=@skynet.be; q=dns/txt; s=rmail;
  t=1597772942; x=1629308942;
  h=date:from:to:cc:message-id:in-reply-to:references:
   subject:mime-version:content-transfer-encoding;
  bh=zKYHs+klvwgIPbT2SGaBcEdIR1kfh0mcf5Im/4W6QtE=;
  b=aEi3FPaN9J9j1fQF+62TQCH0JMuCB5oaQNijVB1usFqBVBws+VQpBIpW
   1BkOp8Lx63IHEcYO70oNghz+RdGfS99+LyLc6AF4IDoWb0RMG98hxqHUB
   pChtekrm4bUUuKiaXKUepjblPwd3iyR2YEQZCBOzeyGDjuhv7/z8hKVcU
   w=;
IronPort-SDR: 4Cch0J3XmjVrg1puVEzlLnmhvt0JQoju4PqNfwbz3sUi7NBbJfFIEJEu6/jEjQpU1JHrPEOWCb
 lrKwxF7rRyE+6ZLw7wCpM6F5tEGjxX1p1gapEJd0geoift+uQj/NFLPRv3zbzQZ+/sDpfbJEfL
 IBP6qidJ+4pl4YWUbqh2N65x151StSBmO2xUxMelDlMIzUAMsE6PO+nOw9SajZweXjM+XRZHxI
 hAzOsKxKftVTiZ+3ikvB0vxShC+xWDFuwQCsBgGlw6oT/mlSlbus2MC6OmDwj9NmoQpRItuwqY
 1zQ=
IronPort-PHdr: =?us-ascii?q?9a23=3AeKyK1hIk1iy5HBmsXNmcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXKP//rarrMEGX3/hxlliBBdydt6sazbOO7euxByQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagYL5+Ngi6oRnQu8UZhYZvK7s6xw?=
 =?us-ascii?q?fUrHdPZ+lY335jK0iJnxb76Mew/Zpj/DpVtvk86cNOUrj0crohQ7BAAzsoL2?=
 =?us-ascii?q?465MvwtRneVgSP/WcTUn8XkhVTHQfI6gzxU4rrvSv7sup93zSaPdHzQLspVz?=
 =?us-ascii?q?mu87tnRRn1gyocKTU37H/YhdBxjKJDoRKuuRp/w5LPYIqIMPZyZ77Rcc8GSW?=
 =?us-ascii?q?ZEWMtaSi5PDZ6mb4YXAeQPPfhWoYr/qFsAsBWxChWjCuz1xDBLgXH7xrE63u?=
 =?us-ascii?q?Y7HA3axgEsA9ADvXLJp9v1LqcSVuW1wbHIwzrZdPxW2C3y6I7VeR4hu/GDQ6?=
 =?us-ascii?q?9/ftTLyUkuCwzFjUibpIvrPzyPzesNvXOW7/FjVeOvjW4otR1xriK0ycgyk4?=
 =?us-ascii?q?TEgJ8exV/Y+ytj2ok1OcG4R1BhYd6iCJZdtiCXOpZ5T80sXWxkpCQ3x6AatZ?=
 =?us-ascii?q?OmYCQExogqyhrDZ/GbbYSF/xbuWuieLDp7hn9oZbCyiRau/EavyuDwSMa53V?=
 =?us-ascii?q?BXpSRLldnMs2oC1x3V6sWfUft9/lmu2TKL1w/P6uFLP1w7lanBJ54n3LEwip?=
 =?us-ascii?q?weulnAEC/ugEj6kbOael8r9+Wr8ejrf6jqqoWfOoJ2jAz1L74gldalAesiNw?=
 =?us-ascii?q?gDR22b+eOh27L95UD5W7BKjuEukqnerZDaOdwXpq6nDA9R1YYu8xO/AC2n0N?=
 =?us-ascii?q?QcmnkGI0lKdwybg4T1OVzCOfb4Auuij1i2izhk2+jKPrznAprTMnjOiKrtca?=
 =?us-ascii?q?pn50NTywc/181T649OBrwCIv//Qkrxu8bZDh89PQy02eHnCNBl24MQQ22AGa?=
 =?us-ascii?q?GZPbjJsV+L5uMvJfeDZJMPtDnmNfcp/+TugmMhmV8BYamp2oMaaGujEfR8Ik?=
 =?us-ascii?q?WZf3vsgtAaHGcQoAUxUezqh0eeUTJJe3myWKc87CkhCI26FYfDWpytgLuZ0S?=
 =?us-ascii?q?ejBJJZfWRGCleXHHfuaYqER/kMaCOWIs99jDMET6KtS4g71RGhrAX60aZoLv?=
 =?us-ascii?q?LI+i0EspLuzNt16PfOmhE26zN7E9+Q02eTQGFokGMIRjs23Lxhrkxn0FuD1r?=
 =?us-ascii?q?J4g/NAH9xJ+/xJShs6NYLbz+FiBdDzVBnMfsyVSFa8RtWpHzcxQsgszNAQe0?=
 =?us-ascii?q?x9Acmtjgjf3yq2BL8Yj7qLC4Io8qLS3njxI9p9xGjc1KU4klYpXNVPOnOihq?=
 =?us-ascii?q?Nk6QjTCJDGk1+Dm6apa6scxijN+3mHzWaUu0FYSgFwW73fXX8DfkvWscj55k?=
 =?us-ascii?q?TaQrCyDrQnKBVOydKcJaRQb93kllNGS+n/ONTQYmKxn3uwCgiSxr+Wa4rqYW?=
 =?us-ascii?q?od1j3HCEcYiwAT4WqGNQ8mCyenvW3eECFhGkzxY0737+l+p220TlUuwwGJcU?=
 =?us-ascii?q?Jhzby19QARhfCGTPMTxL0E628drGBPAFuz1tTRQ/CaphRge+0Ietkn4UlG0k?=
 =?us-ascii?q?rDugB9N4DmJKdn0A0waQNy6m3n3RR+DM1ui8UmoWkrxwk6fayR2l1pbDCJ25?=
 =?us-ascii?q?3sfLfafDqhtCuzYrLbjwmNmO2d/b0CvbFh8w3u?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BKAgDpEzxf/1cLMApfHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgUqDGoEzhDeRJIoXkX0LAQEBAQEBAQEBJxAEAQGETAKCHyY?=
 =?us-ascii?q?4EwIDAQEBAwIFAQEGAQEBAQEBBQQBhg85DII3KQGDEAEBAQMBI1YFCwUGDgo?=
 =?us-ascii?q?CAiYCAlcGExGDFoJXBbEVdoEyiSuBQIEOKoVPh2uBQT+DI34+h1SCYASPSYt?=
 =?us-ascii?q?WmxCCbIMMhViRSxOgI5Uvnl6Bek0gGIMkCUcZDZZphX9yNwIGCgEBAwmQbAE?=
 =?us-ascii?q?B?=
X-IPAS-Result: =?us-ascii?q?A2BKAgDpEzxf/1cLMApfHAEBAQEBAQcBARIBAQQEAQFAg?=
 =?us-ascii?q?UqDGoEzhDeRJIoXkX0LAQEBAQEBAQEBJxAEAQGETAKCHyY4EwIDAQEBAwIFA?=
 =?us-ascii?q?QEGAQEBAQEBBQQBhg85DII3KQGDEAEBAQMBI1YFCwUGDgoCAiYCAlcGExGDF?=
 =?us-ascii?q?oJXBbEVdoEyiSuBQIEOKoVPh2uBQT+DI34+h1SCYASPSYtWmxCCbIMMhViRS?=
 =?us-ascii?q?xOgI5Uvnl6Bek0gGIMkCUcZDZZphX9yNwIGCgEBAwmQbAEB?=
Received: from mailoxbe007-nc1.bc ([10.48.11.87])
  by privrelay100.skynet.be with ESMTP; 18 Aug 2020 19:48:58 +0200
Date:   Tue, 18 Aug 2020 19:48:57 +0200 (CEST)
From:   Fabian Frederick <fabf@skynet.be>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Message-ID: <185851852.53771.1597772937306@webmail.appsuite.proximus.be>
In-Reply-To: <20200818023935.3bee52fc@elisabeth>
References: <20200814185544.8732-1-fabf@skynet.be>
 <20200818023935.3bee52fc@elisabeth>
Subject: Re: [PATCH 2/2 nf] selftests: netfilter: exit on invalid parameters
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev14
X-Originating-Client: open-xchange-appsuite
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 18/08/2020 02:39 Stefano Brivio <sbrivio@redhat.com> wrote:
> 
>  
> Hi Fabian,
> 
> On Fri, 14 Aug 2020 20:55:44 +0200
> Fabian Frederick <fabf@skynet.be> wrote:
> 
> > exit script with comments when parameters are wrong during address
> > addition. No need for a message when trying to change MTU with lower
> > values: output is self-explanatory
> > 
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  tools/testing/selftests/netfilter/nft_flowtable.sh | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
> > index 28e32fddf9b2c..c3617d0037f2e 100755
> > --- a/tools/testing/selftests/netfilter/nft_flowtable.sh
> > +++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
> > @@ -97,9 +97,17 @@ do
> >  done
> >  
> >  ip -net nsr1 link set veth0 mtu $omtu
> > +if [ $? -ne 0 ]; then
> > +	exit 1
> > +fi
> > +
> 
> As some of your recent patches are also clean-ups, perhaps you get some
> assistance from 'shellcheck' (https://www.shellcheck.net/). For
> example, this could be written as:
> 
>   ip -net nsr1 link set veth0 mtu $omtu || exit 1
> 
> or, I'm not sure it's doable, you could get all those checks for free
> by setting the -e flag for the entire script. You would then need to
> take care explicitly of commands that can legitimately fail.
Hi Stefano,

	Thanks a lot for the tip. I'll let original script developer decide wether that kind of syntax is interesting or not and resend this one if necessary (a lot of ip tests are already done this way in the script). Idea behind my recent patches was to enable testing with different MTU but other feature ideas are welcome :)

Best regards,
Fabian

> 
> -- 
> Stefano
