Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12202E300
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfE2RQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:16:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45408 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2RQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:16:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id t1so3513275qtc.12;
        Wed, 29 May 2019 10:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=SmxZsC4yp+0dUjsfC/VFcgwO82eukqAJB5Z3DNdHI4E=;
        b=I+sK8QNzJlifEmDJtSUEdxA7iMf5DhE7PlDCj12D4Qj2JYeD5fetrgUO9tTi4zJVWt
         sWCMKnC6+PWvOFyxujnPVTlSMC+06s/ZFECg7tAdqhtVB8wAHpPU1onboRch84UjNchQ
         hpntKi+NJsl8KPRsr59nD15p5SgD29xhYTJpEkT9vAoL/QaQhCAVR+RJQ/bmTjYwBZp+
         B9U5UtRArgGD7oAphH//USy7HuUfGyzulwHGPg2c3UCGqJDDJWNxs6JLDPbIsNpG7ERB
         xsCRfswZsPFXv+njq8y+RIhY7EzDb5wYZJtNInvehJLl0kBxuSJ74qB3W6xF4B7l8/oM
         PryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=SmxZsC4yp+0dUjsfC/VFcgwO82eukqAJB5Z3DNdHI4E=;
        b=hjzNJRgcbVmsYalQ0ry4k9U77E4ZH4KCYPpHjgDm9BYvZuqSQMNYKGdN6lXKr6mfls
         xK6hXDBQI2TEu8u/BH4HsVeedEejfKY49Lsvvh/LtOXIDEw61lecU0wdoYGLqkyXWsFk
         OaYov75oylnzSv0mcY+p7/2XChMQqanVStQ2DvBTmRGvuBpTeoyL4RzEXaYCgqT7QnIt
         Aok+JHN02mUnuhNGAKbvf2dM4f/7txxXFRG+sL6Xvr1GU2r6nlSP8hFYdzv4/IzoGrX/
         xW/ipk0yGzXQQ1+M8YLHLGUuDDZF6Vn2/7v+eiORh/+BC3fvpfjbiVOfDNKBnr2lOHBs
         xD/w==
X-Gm-Message-State: APjAAAUdMS+r4ErS9IZS4mpolnkX+fag1ZlqgKYe4PeffwjNDslbg97G
        QXomboMIzsq7V5eyyGdzZdI=
X-Google-Smtp-Source: APXvYqyeTdXQQ0wiOF0uUEZ40xhw5VKlxSPQGphUQ+KBhDBML5M9qmxu7Kp14PeiFtCOBA8B8KoKzQ==
X-Received: by 2002:aed:24f4:: with SMTP id u49mr4066213qtc.8.1559150185996;
        Wed, 29 May 2019 10:16:25 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y8sm27716qth.22.2019.05.29.10.16.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 10:16:25 -0700 (PDT)
Date:   Wed, 29 May 2019 13:16:24 -0400
Message-ID: <20190529131624.GD13966@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
In-Reply-To: <20190529070158.7040-1-rasmus.villemoes@prevas.dk>
References: <20190529070158.7040-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Wed, 29 May 2019 07:02:11 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> Currently, the upper half of a 4-byte STATS_TYPE_PORT statistic ends
> up in bits 47:32 of the return value, instead of bits 31:16 as they
> should.
> 
> Fixes: 6e46e2d821bb ("net: dsa: mv88e6xxx: Fix u64 statistics")
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Correct, this 4-byte stat must be stored in the lower half of the
8-byte returned value:

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
