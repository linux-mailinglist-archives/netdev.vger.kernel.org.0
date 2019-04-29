Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C370E5AD
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfD2PCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:02:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34387 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfD2PCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:02:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so4314789pgt.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 08:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=77ow54CgaXjj5cjAYE2H0LMs7A26Lujq7BYje1Kz56g=;
        b=l/PBjDj/48qpvuWwY+4y+QJ3zqmZYbTJdqONqWHczLuadKoQMaW2quXpBxcjjJ+9/J
         PYCzNRSe/uIie8KK2LqWmz7irKHjESyORDUAy+VhCPoRDSNFQ75rXwchPtCj3NvCxerx
         uTKguKrzNsTt53qYPZmwCHDnnB5sauxgwhco22s83T8pEFAPdLYq+SFl9Z00bwOUEjeU
         ZJdqS791ilHM2Zya0XFHyCQhQnwaepgpyKohkfANgacilSNk9/1ZY5cJBnbSzqYHPic8
         G1gkBzwNor73NQgFvv8L/COWEjszyWOR9Iv3nFhcyQNHEzoDCeRWOIfK8hXbjKbE1M9e
         9vwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=77ow54CgaXjj5cjAYE2H0LMs7A26Lujq7BYje1Kz56g=;
        b=V001rWi31ZKSBnF0wuIy+uEmbhWwC9WZnCJBklZBUAwmFH1dHRT6QMDioMdiNB0RHt
         WQN8Z7wDlQ/oGRwZOXTWM0HmvNvKyUJTT1V3H4Xek1ib7BTbOQQkLtBImvkrXHcLWzuF
         qqCAOQM0pUPPeHaXCr27YtCKrEAmsJV6EtApxBpCEuim6ikGuqFNECvazOBY06qzrGrS
         +7Nh5nhXob5WT+5MNSg/dojQgs2o0OSKXdsxuP+bvfXKm9jePu3muZ7Wi630/RNe2+W0
         7s7zdU/Y9U+2Jvl8yTiY8tw0ihY9Iuxmq6iyva4pHECWoVJ+23Fli3OKo8eRsdvn8w1x
         csrw==
X-Gm-Message-State: APjAAAVSVyAjGE91+zQl7fr4tjuFgZVwxK/6Ek5Pq+7cldx9PT33ysVX
        Qg3gWLDxnMfKb0CyC+7lLuo=
X-Google-Smtp-Source: APXvYqyFFJuX6TFm3kdaX38ZIWDrSTwzLRwRqryVjTagtnnj1Ll2QwSZqNqyJiuFVQOQzx6o05PpAA==
X-Received: by 2002:a63:e22:: with SMTP id d34mr54618576pgl.251.1556550165298;
        Mon, 29 Apr 2019 08:02:45 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id x23sm11445609pfo.175.2019.04.29.08.02.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 08:02:44 -0700 (PDT)
Date:   Mon, 29 Apr 2019 08:02:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Stephen Mallon <stephen.mallon@sydney.edu.au>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net] ipv4: Fix updating SOF_TIMESTAMPING_OPT_ID when
 SKBTX_HW_TSTAMP is enabled
Message-ID: <20190429150242.vckwna4bt4xynzjo@localhost>
References: <20190428054521.GA14504@stephen-mallon>
 <20190428151938.njy3ip5szwj3vkda@localhost>
 <CAF=yD-JLcmyoJ6tq1osgrQbXs6+As0R+J-ofU+XwQWcvaW+LBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-JLcmyoJ6tq1osgrQbXs6+As0R+J-ofU+XwQWcvaW+LBg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 10:57:57PM -0400, Willem de Bruijn wrote:
> It is debatable whether this is a fix or a new feature. It extends
> SOF_TIMESTAMPING_OPT_ID to hardware timestamps. I don't think this
> would be a stable candidate.

Was the original series advertised as SW timestamping only?

If so, I missed that at the time.  After seeing it not work, I meant
to fix it, but never got around to it.  So to me this is a known
issue.
 
> More importantly, note that __ip6_append_data has similar logic. For
> consistency the two should be updated at the same time.

+1

Thanks,
Richard
