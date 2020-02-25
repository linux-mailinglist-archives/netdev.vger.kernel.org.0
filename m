Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570E616F2C3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgBYWwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:52:39 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44971 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgBYWwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 17:52:38 -0500
Received: by mail-vs1-f67.google.com with SMTP id p6so549546vsj.11
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 14:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7MQONwXqnHZRXQDO+5cFHOizIPUenx2kjrngECUQSQ=;
        b=ML4KwGNSQIrO0D7ruk1fYSg4pB4VLASqOhJQ3+uvt30zctxClfPEpcN/raNLCNmle0
         SzlFwyCZJpsknAC2v7Mx6mWCveGnkD2zRjQq6VBxAdF6c4ozhJ2E419eCZdmA/VTqlB5
         gtjdkt9Xhdv+Hl8JBcTplN/eAA3umRtDZL0Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7MQONwXqnHZRXQDO+5cFHOizIPUenx2kjrngECUQSQ=;
        b=CdAAlzU0gttky1A6qZPQBefw7HgWZXblUl0sRrZD1RVaCEIIW55Z8Prpr3oGEOdgkX
         vSe2ea62wWYWKGIcRDQcgOQ20gnezEBxFh5zpi22oj786Jd8SPPEncIZ+mdnP//2OK74
         7U4n4c5IYGZUa3GQhEPIM1FgtVeHW6aMVCXW/ALUJTM7yfJ/P3IqOwbHVga4mdsbxfQC
         q+y2Nl2yucBkjHSj8tF0ureNZBIy25P8DXUhBWO5bPrL9TeZH+m2aEBlbb1Pb0lq3mYF
         MthCTX3jXAms/yQmVaM5LYYysXZbaMml1gSXa5Z6/t2JI/5hQ6t1Xtxdwi268HC+RNgZ
         hGDw==
X-Gm-Message-State: APjAAAV4n0B7U3srWf983J0zTRPR7t6TJfOZEtO5SQqDlYiWYQnQACU3
        ncMbX8vI0XbdIoUzr8fvE476kFFF01U=
X-Google-Smtp-Source: APXvYqytWmVsXky6D0fLK4xSr9s8R16r1pLJ2q25tE3sI564eBbbHexjHMUg+rlg50kOcZZu2CqIDA==
X-Received: by 2002:a67:4c5:: with SMTP id 188mr1378926vse.43.1582671157851;
        Tue, 25 Feb 2020 14:52:37 -0800 (PST)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id b128sm49486vsd.9.2020.02.25.14.52.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 14:52:36 -0800 (PST)
Received: by mail-vs1-f53.google.com with SMTP id x18so582166vsq.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 14:52:36 -0800 (PST)
X-Received: by 2002:a67:e342:: with SMTP id s2mr1474052vsm.198.1582671156402;
 Tue, 25 Feb 2020 14:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20200103045016.12459-1-wgong@codeaurora.org> <20200105.144704.221506192255563950.davem@davemloft.net>
In-Reply-To: <20200105.144704.221506192255563950.davem@davemloft.net>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 25 Feb 2020 14:52:24 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
Message-ID: <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Wen Gong <wgong@codeaurora.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


On Sun, Jan 5, 2020 at 2:47 PM David Miller <davem@davemloft.net> wrote:
>
> From: Wen Gong <wgong@codeaurora.org>
> Date: Fri,  3 Jan 2020 12:50:16 +0800
>
> > The len used for skb_put_padto is wrong, it need to add len of hdr.
>
> Thanks, applied.

I noticed this patch is in mainline now as:

ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue

Though I'm not an expert on the code, it feels like a stable candidate
unless someone objects.

-Doug
