Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC273E2190
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 04:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbhHFCex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 22:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhHFCes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 22:34:48 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162E9C061798;
        Thu,  5 Aug 2021 19:34:33 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l19so13785103pjz.0;
        Thu, 05 Aug 2021 19:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=YTL8rATwgxSuPGDhJbThhFcHRN/9Vn25uHPn0zaGPNM=;
        b=X5I4I5hSZKO0FqOT8VVX6wA9MndpzlwOJSH1gYjIYGXpIfLfM3aat5kka3JlkO4NFn
         ZWhYW53gk9CUN+zYaKp3kz3eDOopUYqQNjPGwZdn1f8ib0ZyQfE4SUxwtV7nq6+dmrGP
         Vv9GchnSClXOq96Dy2xcpzTChtwai4GvWHp/BJbKMn8d6tK7CoQod1katCU/OUcNvOSz
         cGrFcFlZFrfhxyTQqLLmh9m8yV5OXB2dRqqP/f52j8elj3xFjJNJdpyNbA51iyIb1HQN
         I1CMXbd8q58ux+urT/kRwZfbaLfAIEQV0D6s9FQhHOUj3Ui/kDt3SgYe12XQnsVNBJcr
         +5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=YTL8rATwgxSuPGDhJbThhFcHRN/9Vn25uHPn0zaGPNM=;
        b=QTMXsiMwR679yCQHfEF37zlHwDzxfERdAEm0mJKWpaXZRhXaWwI4aw1BgCeXUZhH6q
         inDAoQ6E689NRFCe4lT/9AuJti3lnadoOtp8Urf6CyK3v+dhMpHEJqE/3mPsqQfQxG24
         SNgEcVy/CRvD9avSJcRnvk/pzpuz0dV2oD77ql7Wc0mhlnNtl/MdekXw/LmKiXXgwyNn
         lPfGswXg8mE1hAPGX7cIUsbTzh8Dj7USszpQvVz4HUKn0L0OdDXGlI9MBw6UZPthVgsi
         4fA5sQIIfK6EUjkZb8R1LpD1ZzBGxdZM/3p01r2Uu44HyL+JgR54iigH6Gio7QDq76SM
         W/Hg==
X-Gm-Message-State: AOAM533DwkpcjVPw48fr3BMiPctsYCJpxuaGuJmX1XCylq2Tqlcvnupn
        FAALLjJj8lAKxL4vItbQNgs=
X-Google-Smtp-Source: ABdhPJwidkXXkUXiIi8CIl8fimh1qfF44CfoC43Ahyp84TqgG6PJhxxSaLVSz+5tjMZn88RSbcxqSQ==
X-Received: by 2002:a17:90a:1b2a:: with SMTP id q39mr7615105pjq.219.1628217272638;
        Thu, 05 Aug 2021 19:34:32 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b5sm7190597pjq.2.2021.08.05.19.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 19:34:31 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mt7530: drop untagged frames on VLAN-aware ports without PVID
Date:   Fri,  6 Aug 2021 10:34:23 +0800
Message-Id: <20210806023423.519560-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806001740.cayorz3vlfrvk75l@skbuf>
References: <20210805172315.362165-1-dqfext@gmail.com> <20210806001740.cayorz3vlfrvk75l@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 03:17:40AM +0300, Vladimir Oltean wrote:
> 
> Good catch with this condition, sja1105 and ocelot are buggy in this
> regard, it seems, probably others too. Need to fix them. Although
> honestly I would probably rather spend the time patching the bridge
> already to not accept duplicate VLAN entries from user space, just with
> different flags, it's just too complex to handle the overwrites everywhere...
> Plus, bridge accepting duplicate VLANs means we cannot refcount them on
> DSA and CPU ports at the cross-chip level, which in turn means we can
> never delete them from those ports.
> 
> Anyhow, enough rambling.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Please allow me to send a v2. This sets the CPU port's PVID to 0
on boot, which causes some undefined behaviour..
