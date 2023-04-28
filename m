Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F5D6F1277
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 09:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345533AbjD1HhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 03:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345451AbjD1HhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 03:37:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71983270C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:36:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2472a3bfd23so6486101a91.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682667402; x=1685259402;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XNddqsJEyDvWQdRX55z/igDCPnaQ1U9b7eKMExzg2T4=;
        b=JIRBAwrQ0TTXNclDxu9t4J+Z3zOyYY74CwDnXXUnvGml4vzP40Q37khVlWITYVmywG
         ZHIr/RzKsiOhS/qIrsbjkUAn28yEDB+rP1XraELNY0GixXhTKTdgXJHl6MLXWmBpLQG/
         iICUYYXP73Yw7T1Nhmd9adCujs8BNAogEIkYBbgqpwd3VoDCbJp+n2QA361EUPYDeZJC
         Pz4aubKuRw//ciw4hAHMOQBP/cfGOZAwOl/MQzW2ah+USTQVtyYdOHAD4Yq5GySkCGty
         5PULmGVZvi9n18XEJ/j2wuaJlMDkXuFG2BHCj4Gf3KyZ0gqIjBErSo4bTPZIC+o7oR4I
         TC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682667402; x=1685259402;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNddqsJEyDvWQdRX55z/igDCPnaQ1U9b7eKMExzg2T4=;
        b=dDybtakBOxF0+1cAJat9Y8V1OWzt0sRMp6JlqcJlkSzX/KY8GmNf3CB1IyLirUIHTL
         CFtyWCeHDf+m7YLxTAg3sk6RIsr7EEowo/8kJKbOAYnZ4nCw8Mov3Gl1SKGvj6ZJKD/4
         Psc6HkA9f9xv18IeAt2caJFhQ79pZXhmmqzLeSB+kANj5NaPrcqEUa8J5dSpnu7tiRTe
         YZ7m8j54AKtO0wVehYjTgpi8iXlNKHv+UhXaw7Bu747KLCeINlsqjT+BviYMX8FtKXG4
         2kwmHq84ueVB3I3+YnPNyhp9wO3Pl0GkkVQLRiYAXxaDNOGVcyWTTRkll/xBli/BVVvL
         dO2w==
X-Gm-Message-State: AC+VfDyafUbClZcBYPHbha7s+9ApNdTinh70CC0A57GJdVNjwDoja4dD
        a1t+9xRhzSzJr8PUoqTVaO94T9mUlCGT3Y/h
X-Google-Smtp-Source: ACHHUZ56hSGSwPuHj0f7VwvTNTQTVElGNwzdLjsAN0Tc3GEdJ9xxzFUyO950c5FwmzW6JRZTOKMhqA==
X-Received: by 2002:a17:90a:4b05:b0:249:7224:41cb with SMTP id g5-20020a17090a4b0500b00249722441cbmr4518180pjh.31.1682667401837;
        Fri, 28 Apr 2023 00:36:41 -0700 (PDT)
Received: from Laptop-X1 (114-41-44-26.dynamic-ip.hinet.net. [114.41.44.26])
        by smtp.gmail.com with ESMTPSA id p1-20020a17090a284100b002466f45788esm878754pjf.46.2023.04.28.00.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 00:36:41 -0700 (PDT)
Date:   Fri, 28 Apr 2023 15:36:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
Subject: [Issue] Bonding can't show correct speed if lower interface is bond
 802.3ad
Message-ID: <ZEt3hvyREPVdbesO@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
