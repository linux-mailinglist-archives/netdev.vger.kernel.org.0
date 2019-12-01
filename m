Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B15910E0E4
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 06:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfLAFu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 00:50:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37286 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfLAFu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 00:50:56 -0500
Received: by mail-pf1-f194.google.com with SMTP id s18so2685023pfm.4
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 21:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zYOqIkkrOhulR+R1m32O6XEYLoZjT35qsqm0yiWLBs=;
        b=X+nh+ZBHksVgX7dKVMxVBsBj1KZZjZv/EJvLb/aI6d+BALnnzPBfB+slQ1TP6DIWju
         7/wTRiM+tgjf0rgVQd6+ewiJSRKa8oqSnY2hr9t26j6M+4KiCvKrgRB85KKlj3hQMfOB
         qL36nhf0lqRkjh+AkWyHAJrKvMAnL6pqV9QoHxBuuelN3gpNOoXoSYcYn9tmEtJXnJi7
         gDC5/7h3cp2uhGrlmEScCX+wJzzpQbj4dLi46GVo2b5MeEmGcPHu8OqmWAtoeK9nEUi/
         nleAWcOr5gA2H4qJAl7sn5mxnppro8bn2QhOcjckhLZ9eT/NFLEdyvmXkuzYKrRvuEwG
         N9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zYOqIkkrOhulR+R1m32O6XEYLoZjT35qsqm0yiWLBs=;
        b=Qsx9Z757/w8DL11WGBYqy6Ps/yQ8kRRUKJmPizKpU923nG7s22c7QfIsv/zLuVb4wT
         tggKEfPsmjY7DETU0bdLxWS4Nojhw0X/mVmRYMOiPhi57aScW9D9NmmEHE0Aps3PP/M5
         /LHblV0qL+D/J+kba1DWgA7el/+vwB1Y8CO/YxmxufwrIhxjZYEF/X0pf59iDnFsCjkW
         tEEQI4OdSW3qccFvv99vk5tafRmoFRpnO1cY8uslb7wG61FJHy8HLIpv2mZjcczDjtrd
         4VGTKkfiPOZ+3JMolt0RCXl8TebQ/w4VG6832AErkytkF9klR9qpvAjTCYF3ePnlMAkO
         qOJA==
X-Gm-Message-State: APjAAAUVtavZ3gwxEqty7U8WMKZX9vas6UasgMvCWk4f6gAh76U/eT6y
        cEj4IpzJm13olZxlvT1W4/uGklFf/2/Xnt3kLZE=
X-Google-Smtp-Source: APXvYqxpnTPUBp63g9HnBvoEtdDMMFdiuQIFq5RH+q/IPqMM3m9gPAiSKgWod9IwM7FaGhyYb34qprCRJlNlFV6JSlE=
X-Received: by 2002:aa7:85d7:: with SMTP id z23mr65411253pfn.24.1575179456115;
 Sat, 30 Nov 2019 21:50:56 -0800 (PST)
MIME-Version: 1.0
References: <1574848877-7531-1-git-send-email-martinvarghesenokia@gmail.com>
 <20191127.112401.1924842050321978996.davem@davemloft.net> <CAM_iQpWu9DQ06FYo7xtuLFnHP-wx35Uva_0-im7XwemKtLno0A@mail.gmail.com>
 <20191201045727.GA2548@martin-VirtualBox>
In-Reply-To: <20191201045727.GA2548@martin-VirtualBox>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Nov 2019 21:50:45 -0800
Message-ID: <CAM_iQpUZECPes-WxQnPo19=vehTqzW_yfJrYbuUB5bAPJEdkfw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the packet.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pravin shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 8:57 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Fri, Nov 29, 2019 at 10:07:53PM -0800, Cong Wang wrote:
> > On Wed, Nov 27, 2019 at 11:24 AM David Miller <davem@davemloft.net> wrote:
> > >
> > >
> > > net-next is closed, please resubmit this when net-next opens back up.
> > >
> >
> > I think this patch is intended for -net as it fixes a bug in OVS?
> >
> > Martin, if it is the case, please resend with targeting to -net instead.
> > Also, please make the $subject shorter.
> >
> There are few upcoming features to net-next from my side which relies on this fix.
> In that case should i post against both net and net-next ?
> Please advice

If this is a bug fix, you only need to post for net. Then David will
merge net into
net-next regularly, after that you can rebase your feature patches
onto net-next.

Thanks.
