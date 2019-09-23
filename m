Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F39BBCE1
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 22:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbfIWUe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 16:34:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33647 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729065AbfIWUe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 16:34:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so9863516pfl.0;
        Mon, 23 Sep 2019 13:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EGYPKi+Bj97Txmrg48DsS4RTp4MiyYLZEEl8Gx4dbp8=;
        b=jKz83jxo6UQCdidNmrf33fmZCqbVFL/nOB6fiSnp2gNv9JmJj7hWP6gvttTTJSt6j0
         AzRwAdPr3Q1Ev4WZPYct6kzWNZBwOwslDiqquT8VL/ZKKjpiXTZQpneTI/yz2eiuXMVr
         lxvqmNrR6NQuBrnCeWyzMxyHswtKQBbRPGkqinArLe5zePNdPts+8by7W+6h1pA4tLjf
         4I6UH6CdbIWL+O8cXm5deqtBJurbgLj3XGS4E45Qi3tluVvtuchQxkOLhAVazH0aTe0N
         8Kr6y08en2OnR/mIASOeT5gehpa532iH7LzKfLmX/cpjxJamws3moxsebP7JIrdRujZ5
         xs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EGYPKi+Bj97Txmrg48DsS4RTp4MiyYLZEEl8Gx4dbp8=;
        b=qhzMAWVJl0INbfpwTKTDl1C+pFFRIgmGh7AumfFHODSIxAT27+BtuKIsvXL/cnwuxa
         zKh2OS4b/fRoHPNEzrIW617KQQVXT4RuSmsJr3gTt2S1Y1WYig8vilJbzb3RXx1VxE9q
         kgt9qszgaTOu0cU7mA2XV6rNDu2cMzEOAGqJvIXwrDICgVfW/FYaZyJ/DgZFsdFMwpUF
         KZr64oFVNApUjlBGgqOKLt8lg+GcnlCwS+Fh16RkEEGQ4a2v94CaL343RwvOUbswMyzl
         lE55n1k5y88IkoXNClkg5rZXPKBf4bBn9EfipQb5Jk5TwuCBjwhxC5LuS9LwPk5PZPDv
         3Vhg==
X-Gm-Message-State: APjAAAVZVHUzKUyYNTBWRfbX/7tRt/ipiDNHRZtXUYmKDyl23vVhEZkP
        0C7uR0DgDroFnwNK9bl914E=
X-Google-Smtp-Source: APXvYqyNkmREM5d5I86SZMtJX+edL0QFUQzFvJrS6pzQ6ezjgBUHSDocLloyBDJm50K62Mx3Czjxkw==
X-Received: by 2002:a65:4286:: with SMTP id j6mr1787684pgp.218.1569270868145;
        Mon, 23 Sep 2019 13:34:28 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id z25sm12391618pfn.7.2019.09.23.13.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 13:34:26 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hidp: Fix assumptions on the return value of hidp_send_message
Date:   Mon, 23 Sep 2019 13:33:57 -0700
Message-Id: <20190923203357.8355-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <3D70AB75-FEFB-4EB3-9AC8-3BCE90F5458D@holtmann.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am taking this through my tree. And yes, I applied the updated patch, but answered the other ;)
>
> Regards
>
> Marcel

Are you also going to mark this patch for inclusion to stable tree? I haven't seen it in any of the stable queues (netdev, Greg's), so just wanted to check.

Thanks,
Andrey Smirnov
