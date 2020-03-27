Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3089194E62
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC0B0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:26:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37923 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgC0B0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 21:26:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so3047425pfo.5;
        Thu, 26 Mar 2020 18:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6Sl9e1fpV3n/PUpys52AurBxrK0AUmZ3suddAnYhqks=;
        b=BeVatET+VO+W+d6njIuSybcLG2ueAPEpR7q+hJfQpIITnInalrOAqMeQcUOvY7pQp+
         dg3SWej0qU7JLF6MxUWvKl3fXoUhMzLHyLSXZixz0QwvdN+nB97C4Fpj9uKDv9mZDJME
         lFOEZ7PjF2pf/K13P2L2bUhh4/kIFmKQdRcsUN22SNYbL/cSc3RpoMY1uWt6BhJTufYw
         btBwoAjUIJ9O0NoFAW1T9FfJCMI8wja/cMLn7iMMn2k45amz+mGrmLRFJtjosFA7KxHa
         fLf9OlKbDJJODH6csvWhn9NInOd0IDdMbUgArn6E4nq4XwRKJdgawhmbFNjgj9L4UjoO
         G37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6Sl9e1fpV3n/PUpys52AurBxrK0AUmZ3suddAnYhqks=;
        b=KvXq473S+T2XVCtmxVRbiuUSlPhDCHUvICgZXfhUAmXOoUDuJeVdxlaoQGqtzqy4/B
         uNyDSokUfNS2Ow8hAV0mYza3GkpVWm05+fzzpoIpCLxpP75rXILKYKq4XdkC2OPMMxN+
         oImqvsL25cYyTmxL/HxUSDJ0ZeViHIlRW/oyiv8Gic3BW2fEpL7naUbU7JoFnqhsbUpk
         Ig1SFAxNDDru10e3c8N/E26mEM8ajX+6eiT6iJpYHVlS5QiRRg38ApZF0vs7NIZJCuj6
         3vmHq5RNnX1j2fvzg003OGgVL4+GFNJpuXyNl5a2JJK2KkZNjyIdmjuxKkKZWWFrYZEa
         519g==
X-Gm-Message-State: ANhLgQ0qi7GTxIgZNUp1OAe0Mn+YhwteB3Ecu7vAMF6yNdNzA7dvd7aK
        G3ArsbSFfrA90cxBDIXf4ZU=
X-Google-Smtp-Source: ADFU+vtL88oQlNeFSjMNkmS7nCbdPob1bFnZKbDmOLBXFNOJ2mLvWafcaKDgmiB2Iu82JsgI/qK+hQ==
X-Received: by 2002:a63:100c:: with SMTP id f12mr11260613pgl.185.1585272369760;
        Thu, 26 Mar 2020 18:26:09 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i4sm2549027pjg.4.2020.03.26.18.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 18:26:09 -0700 (PDT)
Date:   Thu, 26 Mar 2020 18:26:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 03/11] net: ethernet: ti: cpts: move tc mult
 update in cpts_fifo_read()
Message-ID: <20200327012606.GA9677@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-4-grygorii.strashko@ti.com>
 <20200326142049.GD20841@localhost>
 <f91001c9-2b11-53ac-84a7-11e1e94c5dc9@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f91001c9-2b11-53ac-84a7-11e1e94c5dc9@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 10:18:18PM +0200, Grygorii Strashko wrote:
> I've been thinking to squash them. What's your opinion.

I favor small, incremental patches.  Just the motivation for the first
patch was missing, that's all.

Thanks,
Richard
