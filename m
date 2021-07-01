Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD83B941F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhGAPmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhGAPmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:42:35 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C954BC061762;
        Thu,  1 Jul 2021 08:40:03 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id g8-20020a1c9d080000b02901f13dd1672aso4479808wme.0;
        Thu, 01 Jul 2021 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3d1/y8CJLKCSBr4EsHmH8zFaiN252FdPYFFuHvdt5Fo=;
        b=FQxikW28LOSxCdBf1R+ZchUmn3KM+B4UEWA2qzea9w88sCbE7MBH9Ua1TlXXMXsads
         It/c2J09TJXMLUdRjfkVvsIDAIgnS4/AS9p/LVEe4GT1AlzYu/4fOJfyMSim7elf/Gu3
         uJXKVeCXM3vlKFySzzOE+IlYnzedp7xVK+MOCUA+FvtcZxeOcvCpOZp39sUQT8rt7wgP
         /EvqdKecQHNQy6VMTRHKwBOwvt4tJ6vrreYDkK/hDv3+NxIQ6jFsAH+J7VfXdo35sXff
         HJsy1/Kc/mecrayYcFlTHbkRLQaoZ4VWl4GfvXQTjKnqcOqG2HZeewjcKxazQEdnBKHd
         l8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3d1/y8CJLKCSBr4EsHmH8zFaiN252FdPYFFuHvdt5Fo=;
        b=p+X/HAaNEwMxtlw+djflajaR+UXzF5fgMyx6owD7Kt5TsElYQN8q68h8JdtuUBNwap
         KXeK5rUzXAvxeUTOdjP6rukwfdk+JxNDNR5SXLH8I5nRR5mWn+YpNc7ZjxErhHlZs+rW
         4PO0U3nsrNTSsXJ/ZlpngJAEk9eBdJ8fY2gAk2aOGCf+loiBzya5scZThVESH8VH9WIx
         qpVjM324xs/4t5w1tSXFBu7M+otv57NV4gvq/oWUdre4LV+liiXeZcVzdKYqmEOYBqIg
         Q0oNqEq0FOxIoKXMgz3mT/gqZBFOXB8X83Tm0aRec1u6CGABIPDrk/XhvFqi23zXkGuE
         2EPA==
X-Gm-Message-State: AOAM530Syxip2tfpm6u+vjflgrGaOvgAHREbx1A9Q2rx95lRPFYZ7klE
        89oVcNwy6xygy5g3m5y0LIQOzuyD/Gdkr9Kn
X-Google-Smtp-Source: ABdhPJze4y1nxUKbHZgfaeBsmoEpGymAtQlSNHz0caBy6Jh2JtyYsOKk+Q5n7yvWRiwswrNvhK/MyQ==
X-Received: by 2002:a7b:c0d6:: with SMTP id s22mr11409797wmh.52.1625154002407;
        Thu, 01 Jul 2021 08:40:02 -0700 (PDT)
Received: from allarkin.tlv.csb ([176.230.197.111])
        by smtp.googlemail.com with ESMTPSA id x17sm414260wrn.62.2021.07.01.08.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 08:40:01 -0700 (PDT)
From:   Alexander Larkin <avlarkin82@gmail.com>
To:     yepeilin.cs@gmail.com
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, avlarkin82@gmail.com
Subject: Re: maybe similar bug exists for HCI_EV_INQUIRY_RESULT* like [Linux-kernel-mentees] [PATCH v2] net/bluetooth: slab-out-of-bounds read in hci_extended_inquiry_result_evt()
Date:   Thu,  1 Jul 2021 18:39:36 +0300
Message-Id: <20210701153936.2954886-1-avlarkin82@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200709130224.214204-1-yepeilin.cs@gmail.com>
References: <20200709130224.214204-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the net/bluetooth/hci_event.c , maybe similar bug could be inside
hci_inquiry_result_with_rssi_evt() that is HCI_EV_INQUIRY_RESULT_WITH_RSSI
and inside hci_inquiry_result_evt() that is HCI_EV_INQUIRY_RESULT. 
