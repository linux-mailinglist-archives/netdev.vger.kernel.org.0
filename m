Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4796EBDC34
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389952AbfIYKdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387534AbfIYKdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 06:33:53 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1FC23CA16
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 10:33:52 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id w198so5571143qka.0
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 03:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZZGk1175G8uwjvxdK1U1C4fRiS6VV+Ha9+4WTc5Wkb8=;
        b=TCXyNvnYp1T1CIMAcgxwqI9aftwjCezK123/1+X1AAcD/smSLlkPdM1vAt2hC7Os97
         ltHtlzX5P3n6wX0ZOs0ryHTFHbydaSjW8eBCkExac2v3CC77CNi/wP3Aq1eeLvKPo5Jd
         ib/3ok4Q5DEcHVzQ254wRcbYo0mH+kvYLPAi78aOxJBdG89ufaBVrIV4P6fmXg7DxpnA
         FvarjRLcIw0Wu7Jb4+mEb9QzaLtiW4rjvVWoQKWbfjb9C9o5+D+ItxONT3y85cGAk9l8
         RstQGVEtFYb8Pz3kGSuUndd58Ky+FBzaFp584VX0mW6TxflxJ6fbGmnoFSOGVKBptW14
         REYg==
X-Gm-Message-State: APjAAAVqhL4evfsXzTXGzKaJ7GhwHCmCTG8FiXxE1TIOr47FjQNgXpA/
        /UC+KvNRYeeJgLHil+0VOT2pmtGYVnwE2jcjP9BsTI9TgK75ukwWz3QeNjSrGwlHikmxBH98Fmm
        N9eVQkHYKAFvLKqCu
X-Received: by 2002:ac8:16d9:: with SMTP id y25mr7908727qtk.72.1569407632038;
        Wed, 25 Sep 2019 03:33:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyx21jj+mlIngD68uZdaLQCpjtwuHMb97xiyJA7Kj8yCO0n3y++SdmxXgWgD4cZyTugtzknMw==
X-Received: by 2002:ac8:16d9:: with SMTP id y25mr7908708qtk.72.1569407631903;
        Wed, 25 Sep 2019 03:33:51 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id x59sm2645454qte.20.2019.09.25.03.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 03:33:51 -0700 (PDT)
Date:   Wed, 25 Sep 2019 06:33:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on
 TUNSETSTEERINGEBPF prog negative return
Message-ID: <20190925063142-mutt-send-email-mst@kernel.org>
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org>
 <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <20190922162546-mutt-send-email-mst@kernel.org>
 <CAGyo_hr+_oSwVSKSqKTXaouaMK-6b8+NVLTxWmZD3vn07GEGWA@mail.gmail.com>
 <CAGyo_hpCDPmNvTau50XxRVkq1C=Qn7E8cVkE=BZhhiNF6MjqZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyo_hpCDPmNvTau50XxRVkq1C=Qn7E8cVkE=BZhhiNF6MjqZA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 03:46:19PM -0700, Matt Cover wrote:
> Unless of course we can simply state via
> documentation that any negative return
> for which a define doesn't exist is
> undefined behavior. In which case,
> there is no old vs new behavior and
> no need for an ioctl. Simply the
> understanding provided by the
> documentation.

Unfortunately this isn't sufficient: software can easily return a wrong
value by mistake, and become dependent on an undefined behaviour.

-- 
MST
