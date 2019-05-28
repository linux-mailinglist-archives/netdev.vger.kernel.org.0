Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF62CD7A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfE1RTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:19:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42598 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfE1RTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:19:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id go2so8596458plb.9;
        Tue, 28 May 2019 10:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vgUukrIUAW33rXBEBk4q8j6YDX0VbSNRvM27fcNOQus=;
        b=qiIXD97ZvDql70kTKKS9X4xm3xxDOG35kgByIN/usE5C3DHxjZMHhJv+DHBHl8KBdO
         TCi0KVHo0oAQmtuu2Q8mD+pxDqAedfY6fUZywhgSHmzXR842hjutueEa/WhwBXsssThC
         RSIY/VZq60PYW4sXqtc/8hC4HBx0MSTEa2aMRAPKCommtvAjdsjGZXVFlsYZ+YGPMURz
         Sqy0X5PZO01U2T1Ydgy03yJNavka7E36iFy2jMGqHE/dNdRJRYo4fyo3rdDXShyYCJAw
         SC2jQcfbcKlGjyjc91nk9GvoooSsdOmkghKOAm+pqxYt/I5rUtWuhEC5Bn+Njhs4O/Fm
         MYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vgUukrIUAW33rXBEBk4q8j6YDX0VbSNRvM27fcNOQus=;
        b=so2qKA0tpVoDrY30K0C6nRGurgKxNs/BdDrx0P1fxLlXsyQyzCkD5ByfZ+czmVp/N4
         SWcVdowQ+4kxtfT8fouaj3DVzxAzw4mHuvyzFWd4aOd3QZJVInsmVclznnZeRJkjex+M
         rqCvLk6vwj7AjH+msgjdlSf7kSvZ3HRbTBC/SaTVcBQqY4p+zZHccAok1s+FKbqjlVVZ
         NXfZ4X1k9HKgXJU0ZLRxa+I5xWYIRTGwg/mCIjz43V5L76CsGFO5BU01fDSDCqQQUat+
         oODWFPHiOpwUX6sx24RmbORJ8NumiDRU1tmQ3qCzY0OIIgbhmV7bReFdO3z/VoRPAczl
         xqWA==
X-Gm-Message-State: APjAAAXtKOvJhwKCxxtshBMITOCdppURkY41niFKYKCXOqZMvhhP/ezf
        x/BDPtODnJMENb834JCRJd1+Jyt7
X-Google-Smtp-Source: APXvYqzA7CK7i0ADM4IDLYfQh8F06vK2xmlmKmhowjBNF8rKaCXnzMAhLikVyJirLNZmlN2o+bWiyw==
X-Received: by 2002:a17:902:27a8:: with SMTP id d37mr27735710plb.150.1559063941574;
        Tue, 28 May 2019 10:19:01 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s27sm19253690pfd.18.2019.05.28.10.18.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 10:19:00 -0700 (PDT)
Subject: Re: Driver has suspect GRO implementation, TCP performance may be
 compromised.
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <e070e241-fb65-a5b0-3155-7380a9203bcf@molgen.mpg.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8627ea1e-8e51-c425-97f6-aeb57176e11a@gmail.com>
Date:   Tue, 28 May 2019 10:18:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e070e241-fb65-a5b0-3155-7380a9203bcf@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/19 8:42 AM, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> Occasionally, Linux outputs the message below on the workstation Dell
> OptiPlex 5040 MT.
> 
>     TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised.
> 
> Linux 4.14.55 and Linux 5.2-rc2 show the message, and the WWW also
> gives some hits [1][2].
> 
> ```
> $ sudo ethtool -i net00
> driver: e1000e
> version: 3.2.6-k
> firmware-version: 0.8-4
> expansion-rom-version: 
> bus-info: 0000:00:1f.6
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: no
> ```
> 
> Can the driver e1000e be improved?
> 
> Any idea, what triggers this, as I do not see it every boot? Download
> of big files?
>
Maybe the driver/NIC can receive frames bigger than MTU, although this would be strange.

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c61edd023b352123e2a77465782e0d32689e96b0..cb0194f66125bcba427e6e7e3cacf0c93040ef61 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -150,8 +150,10 @@ static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
                rcu_read_lock();
                dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
                if (!dev || len >= dev->mtu)
-                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised.\n",
-                               dev ? dev->name : "Unknown driver");
+                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised."
+                               " len %u mtu %u\n",
+                               dev ? dev->name : "Unknown driver",
+                               len, dev ? dev->mtu : 0);
                rcu_read_unlock();
        }
 }

