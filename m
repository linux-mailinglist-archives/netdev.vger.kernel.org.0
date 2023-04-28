Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF99E6F126E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 09:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345380AbjD1Hfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 03:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjD1Hfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 03:35:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC60126B2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:35:33 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a6c5acf6ccso71089425ad.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682667333; x=1685259333;
        h=content-disposition:mime-version:message-id:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XNddqsJEyDvWQdRX55z/igDCPnaQ1U9b7eKMExzg2T4=;
        b=nGcQMiXKfUIC1FGRQxP26gNv7rc80GjuQSqFB9/JSFM8JH+vEFG+aMynuwF935JbtR
         KqP0z+Hxl7dr2o97iWOF6i4swDcCY0uDt7UlbNbrRLbQG3Y9a18uVCCGYeb+pHxSEtQ3
         dkEgGF0oxMH+QKzTSvW1C/zc90xIN3/zwcPoXH2eu2yPuyIkqy56hyU0Cjkxc9dc4PCD
         y+f9G+HO8wQ24PX45ERj7kIXYsO9SuuOQidsNw9r7WWSoTuWFnr8Dro3KI0IAbaVP5SX
         5oXyjei25Gx2TZkkNAmXYH9efVNJqLf26MgX6AmYuFLRUOc7Vn/R+gb4Uc/1DhQB2mRD
         sKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682667333; x=1685259333;
        h=content-disposition:mime-version:message-id:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNddqsJEyDvWQdRX55z/igDCPnaQ1U9b7eKMExzg2T4=;
        b=cSUxhHdSFNwlBnFHDTK2cMFW7KhfMk7NLf8miyFxd2CyKtXL+A3sBlSE5si2UhjCR8
         smV3fRff1XgQq8TwzoHaWWZtekb+Ab4sVZibIB11Ac1O/NwJI3vwqCKqUmzmZbcjglcZ
         tp429hGTTAjEJJzrKs8ejajeX8qEoLIRHeuHcGfsCGMS1Rglw2MvebkBdi6UYny2Tlf5
         zuVw830uGVR62Yk9KqrmXu870A36DUiELDfuErVBf1Hsa96v/xL6iHyGjqq4U2O+Bn6i
         UxajBrTMvSgOKAJunfVZtT2bFT1mlmJbR0qif8fZJ2jVb7VBkR6liVkqsWLQbNlXq2cC
         IQ0w==
X-Gm-Message-State: AC+VfDzkvzdT8kse/roJr+xg/DVW8sqBzjfNSTw00VKagN9Yv/qhuR7w
        v/RvpUFuvkLDsLIxrIHX8tZxHQ510u5SKRbo
X-Google-Smtp-Source: ACHHUZ4hY5e58/46xz2SRz6TDKkxDXWGjVSxF8vW1zusV9UgCxnPghvT61ztCGIzXe0JwU/6L4Ph+g==
X-Received: by 2002:a17:902:cf0e:b0:1a1:a8eb:d34d with SMTP id i14-20020a170902cf0e00b001a1a8ebd34dmr3965690plg.46.1682667333263;
        Fri, 28 Apr 2023 00:35:33 -0700 (PDT)
Received: from Laptop-X1 (114-41-44-26.dynamic-ip.hinet.net. [114.41.44.26])
        by smtp.gmail.com with ESMTPSA id z12-20020a1709028f8c00b001a27e5ee634sm12766766plo.33.2023.04.28.00.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 00:35:32 -0700 (PDT)
Date:   Fri, 28 Apr 2023 15:35:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
Message-ID: <ZEt3QHuKnbUhXkB6@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MISSING_SUBJECT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jay,

A user reported a bonding issue that if we put an active-back bond on top of a
802.3ad bond interface. When the 802.3ad bond's speed/duplex changed
dynamically. The upper bonding interface's speed/duplex can't be changed at
the same time.

This seems not easy to fix since we update the speed/duplex only
when there is a failover(except 802.3ad mode) or slave netdev change.
But the lower bonding interface doesn't trigger netdev change when the speed
changed as ethtool get bonding speed via bond_ethtool_get_link_ksettings(),
which not affect bonding interface itself.

Here is a reproducer:

```
#!/bin/bash
s_ns="s"
c_ns="c"

ip netns del ${c_ns} &> /dev/null
ip netns del ${s_ns} &> /dev/null
sleep 1
ip netns add ${c_ns}
ip netns add ${s_ns}

ip -n ${c_ns} link add bond0 type bond mode 802.3ad miimon 100
ip -n ${s_ns} link add bond0 type bond mode 802.3ad miimon 100
ip -n ${s_ns} link add bond1 type bond mode active-backup miimon 100

for i in $(seq 0 2); do
        ip -n ${c_ns} link add eth${i} type veth peer name eth${i} netns ${s_ns}
        [ $i -eq 2 ] && break
        ip -n ${c_ns} link set eth${i} master bond0
        ip -n ${s_ns} link set eth${i} master bond0
done

ip -n ${c_ns} link set eth2 up
ip -n ${c_ns} link set bond0 up

ip -n ${s_ns} link set bond0 master bond1
ip -n ${s_ns} link set bond1 up

sleep 5

ip netns exec ${s_ns} ethtool bond0 | grep Speed
ip netns exec ${s_ns} ethtool bond1 | grep Speed
```

When run the reproducer directly, you will see:
# ./bond_topo_lacp.sh
        Speed: 20000Mb/s
        Speed: 10000Mb/s

So do you have any thoughts about how to fix it?

Thanks
Hangbin
