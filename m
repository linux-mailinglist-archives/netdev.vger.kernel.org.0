Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CC0375304
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhEFL23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhEFL21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:28:27 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1B1C061574;
        Thu,  6 May 2021 04:27:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h4so5200274wrt.12;
        Thu, 06 May 2021 04:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+jPbk0rmhmh5MmpL8wnVO0FiLn+LfiV1hvh3x092BOs=;
        b=T7WdHApjM9F+V4yoaKhR0n/AVmdMZk/kiQrScUW5xegf4uuI5NURZkWHJr0xGaxycb
         GN/qq1xXzTUjIK/WYmQg8wtwt5Ek228xRXbg1sTpOeby7FNDEW7y/nlgF4FI3/3q7r8y
         T8zo/O79TdKXf0q1sDPHg1gHp5V4LLU1STp7gphLwN4trG9+4rN7f7Uq+KX2xLEni6oL
         X20drE3DZgYp+X3hW4o0fPvZnCHyKB6Ah0MUxZ6uZAkBkuib5IqHSgLY6cvGNw61C5P3
         AWFdr8Afk4tSGCH8JJNUg12kppnoflHSgm3MKF2Z423BPUUWQ63t8yRY2hcUhb4nkj7r
         16Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+jPbk0rmhmh5MmpL8wnVO0FiLn+LfiV1hvh3x092BOs=;
        b=JTeePYQe9xb4dZW2QveymQU1UuPk5aEZQXHf5MYEkSeaLx/2ccHNSqtMoGJmo1wud0
         jWplvDli6lJoHNJxclQtzPXoqDqXi5MrGlEJbj2PtDXARfbNWn2eQAa9Z4Gl+BoiGj/9
         iYbMMdB7P2nGyQNg3GJkdKFkWWDtEIxyi3q3nHv7Yj7JDYOgg+jY0avJCFuo1iMWJNPw
         1uTsqShdCqwt2Ei9GPO2KyfAJQ6i/zhfJ1G5uwCTTjtVUYfrsDi8+j1gyRAzetz6P6w3
         3vgs5I/XwpOzDr9+J5etardo+fdaf3JDTnO+RuqwzSSzi3sYAkvjn/Oc9DBwMlo14yfr
         PEEQ==
X-Gm-Message-State: AOAM530jb5pYC32SXFBr5oxZu6w8a09idE58NQXawfTRrN8qBa0/qxDn
        Z+OiY8Gv91S0eDwJ21j0m27MBkvQV7Q=
X-Google-Smtp-Source: ABdhPJwYBW3QJfHTYOWXoCWy+c02jZzl+UeeLkNTWRCUWakhm9DlAnirrj2pYwB7OqIn65Rr7SFlvg==
X-Received: by 2002:adf:cf0f:: with SMTP id o15mr4497104wrj.181.1620300446593;
        Thu, 06 May 2021 04:27:26 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id g129sm11349233wmg.27.2021.05.06.04.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:27:26 -0700 (PDT)
Date:   Thu, 6 May 2021 14:27:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 16/20] net: dsa: qca8k: enlarge mdio
 delay and timeout
Message-ID: <20210506112724.63s4m5iw4trhdpkq@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-16-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-16-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:10AM +0200, Ansuel Smith wrote:
> - Enlarge set page delay to QDSK source
> - Enlarge mdio MASTER timeout busy wait
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Some "why"s would go a long way here. What did you see? What behaves
differently? Is this only a preventative change?
