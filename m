Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11EF986F7
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfHUWHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:07:11 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:43490 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729339AbfHUWHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:07:11 -0400
Received: by mail-pl1-f172.google.com with SMTP id 4so2087397pld.10;
        Wed, 21 Aug 2019 15:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DKSxsc156ku0iiz6EF6g2xh283us4DQfE+2/khLA+tk=;
        b=EOQxwe1/2UxN6E7cKuyQFM2r8tQb5Qiq2uWBO74Q0vbHTCmDkwNVISEgGPkaqhJbC4
         Lf4D1Kgc5acf8ecVAKgGP7vSQf2qnbb5FYpXRs0xXeUSgGRN09fwaE2/EB6RrY2j+anN
         M8tf6orj1hqJW/1zuMsJxgD6OtRODDGsQCEZmID+DB2NAwinKlckOpISdlX7sBPycxtC
         NIx4nhvwVmD5aWacA0+PDhMrTup+efe/ZbouUrIHKK5eel0KiXx95wHA7HXvWWMSXTCd
         l+oAOtt5S1ucrP3EFErSFN8ENIRjckCtdnXskJZSAsCwor6S1x5sbspGaZ2Bzgt0uOoF
         IHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DKSxsc156ku0iiz6EF6g2xh283us4DQfE+2/khLA+tk=;
        b=JDEuy0sx5GgZZVgPU8/J6EMDW84UCYMxARF5HFlQEjMPoq/LfIT4DqQCRmV+HNepuN
         nqd8Hj9SLX1hd5Ktm/iasdzgF41fDerWZD9aRQjfQY4Zja49OVCxkiEIH58qSQshOAI5
         nqRoHAn33cHKfVy4gEMHyRKBcEzZaJkJ/NoNZVkXngJwhv5zWNo+ZTyoBqBGEnl+HHTJ
         6zRr8CohbtNxUtrJH7jLyKgI4EVXt9scmFO2bwSB3qzGLwfIdiQ6r3YTj9cDyGD3gTyz
         rFKbDIo58jeh83lwirP9jORvuAeFDRPvb8kMUhKoEOfD0VnpdOpu7xiWzIFtdcqtr9de
         lDhQ==
X-Gm-Message-State: APjAAAV0V/9PYM74dOMj1PYNEf881/4y8LIZSMg7VPh7y1P3lkF8tesl
        K/Vy3wGdoY9q8mGeAd0xCUzFdMb5nY+p+XjIztf/6g==
X-Google-Smtp-Source: APXvYqygmKWDo6axcZPANdI1tWaJUn5LAy0JXg6YQOYPrd/6wByl3yqlH1g/ESBdL/5FT+r3YNavIM1umhbT0Naxl6s=
X-Received: by 2002:a17:902:7782:: with SMTP id o2mr36596366pll.12.1566425230102;
 Wed, 21 Aug 2019 15:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com> <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
In-Reply-To: <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 21 Aug 2019 15:06:58 -0700
Message-ID: <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Akshat Kakkar <akshat.1984@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 12:04 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
> I am using ipset +  iptables to classify and not filters. Besides, if
> tc is allowing me to define qdisc -> classes -> qdsic -> classes
> (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
> then how can those lowest child classes be actually used or consumed?

Just install tc filters on the lower level too.
