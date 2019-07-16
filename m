Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA206ACC2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbfGPQ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:27:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40006 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfGPQ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:27:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so10365146pla.7;
        Tue, 16 Jul 2019 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FOjrZcEc61Rup4+xl6Iii6oqyQxM2iUYjWxxcCrF9iM=;
        b=UE5nQGaroUD6q/JmgDD35B3Wz0LtVh3WpYnVmgQCjt3ww9G2tz68hUWHZd6pOcXf3T
         8GIP0bhnm/LEm1GjDxo39sbOVMCZeEfeWbkfT1OVaJCIFZEaZlBZUMuljeovKACt4CYm
         QU/xaD0rGTa+KUWPVp0atWm6VGpU2xUlf3fdGOTFu7TVjisTQDiVNtKWWzQP3wTLCudG
         blFFo4tzjJ4Rkac+sXgfM6b0nfPXeU026LVOkokF7AP9gSuCZXiWhDyHDJXrc1tdHhs7
         IwGaulEM2uo2oKYKD2odYJm4PGbgJa7x8WoD36YbFsSOwy6yxaMYRFEKE/vE3I+krwVm
         B6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FOjrZcEc61Rup4+xl6Iii6oqyQxM2iUYjWxxcCrF9iM=;
        b=G8y7Of4W4IJgKVXXuB373jZ+SVwhur+KOxMOk3F4HAi/ct3BHsRtC0BTy6YDDcy/6B
         v93SYOv2u67bRuX3/GMyTTLayGH01e2nOXw4FjJbNJf2TV7pTtRK9dRfJ2lPZvgrUH8k
         KHtOyTt+NoZYsnaalEMWYDbU1o+Eu7TDoQJEgqv4Ibw5neUhAN+qGsqmGZxu2rSOQ4QQ
         ovsOKyriqYTyTUiQNPayrS/2uWgibznSxeHfGZAO6iCKk7ZZFmZrOyPqLDG6XWzsxDIu
         ddMKygKbHMiPMk/1KssddfxeT+/uFpN+SAOgT3V+BlHwZ/R6yiOhh7+LmH83kyDKF0m1
         ixGA==
X-Gm-Message-State: APjAAAWYt3Ujq7JX2UPfPsSr+6YkZefnPdRJTlfFk98//EXx4yZBf+wL
        heuMnkvTlMFdNJpNNwfBI/0MAnuJ
X-Google-Smtp-Source: APXvYqza0hGDVhs0kcqEHIoxX0MY/HPPW0vEEJLyHMygwq88nkGueV8ff5pIkTD6vsiqxIUhN9KMaA==
X-Received: by 2002:a17:902:934a:: with SMTP id g10mr37532046plp.18.1563294471524;
        Tue, 16 Jul 2019 09:27:51 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::c7d4])
        by smtp.gmail.com with ESMTPSA id f20sm6742782pgg.56.2019.07.16.09.27.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 09:27:50 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:27:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, Y Song <ys114321@gmail.com>
Subject: Re: [PATCH bpf v2] selftests/bpf: skip nmi test when perf hw events
 are disabled
Message-ID: <20190716162748.ooeyasqmrdaeanvb@ast-mbp.dhcp.thefacebook.com>
References: <20190716105634.21827-1-iii@linux.ibm.com>
 <CAEf4Bzaf2Ys6H4h0rk6z+QhP-anonz=MBej5CaShXKL453MB4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzaf2Ys6H4h0rk6z+QhP-anonz=MBej5CaShXKL453MB4A@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 07:57:04AM -0700, Andrii Nakryiko wrote:
> On Tue, Jul 16, 2019 at 3:56 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> >
> > Some setups (e.g. virtual machines) might run with hardware perf events
> > disabled. If this is the case, skip the test_send_signal_nmi test.
> >
> > Add a separate test involving a software perf event. This allows testing
> > the perf event path regardless of hardware perf event support.
> >
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > ---
> 
> LGTM!
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied, Thanks

