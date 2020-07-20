Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0F2226DAE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgGTR4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgGTR4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:56:07 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD41C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:56:07 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so18980737ejb.11
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qSHV8y5hn3Lnoy9++ONiDLzIABrPz7t+jLdeVAdCy6M=;
        b=CJXV3lydGtSQP6rPPyjDl5OQRj72fLRyc69s5nmX5wqv72rYVaIohlDgdQLnorCHB0
         NBRO0Q6l2GOVIiMer6j5bX+YOLljhKRoxJSqiMWm4PqO2VPjE04V6BCEedHRC19dWWf/
         8er/nxg5VT4spllQ4EnsxDH7DzR0YILXKbGh7csufyS5wbLEHjrC3QEpydHYEX676bZQ
         1bI/ExgB3ZiP+r1oRRiEchZ1LfDaDM4VIJseLB0FQ9yZOamnUxfchlNFvyeOi2ABlYzR
         5FV+EC7n8YYWNSkO0UyE6ilqrmyRLBIUX764ORjT3iQB7uKctjxU1whZMz29YqyczTqC
         XOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qSHV8y5hn3Lnoy9++ONiDLzIABrPz7t+jLdeVAdCy6M=;
        b=NZ0CmcWX34DCr8tp14YjhIIdkn53abyvCaHRFgxY4La9YoyQW7Iuthvag7QYc7G+u9
         T9of4ADkobvMkhTtfY8vG65qOGyJJ2ZNmNSpgu0lEKTkvnQR9C/fwwP36OAYjI5alwK8
         YYJl4auiBPbq0nqP7vWn1o65+y2AP3Ybua7S0L0GlueA/lne7E22LsRCcOxPdYVfsynq
         7XZ0jatxq9Q6NuCZqe31awEc4Z8G8qOxCx9Z6ToKVFDVeAdWw5n6P/DjZcHfLo55cuqt
         o2QenZ3oEcwvsmg8JkqfCPccxKFMtQf0VcwZUiNGpbYS0v8t9Gr+5c9ksby1wlnk9Dpe
         U2Qw==
X-Gm-Message-State: AOAM532Zt6u/+6NIC7l0eqabso030RP4raxzqYK3XjWEizy08Y0guuh6
        YmWxJAyr4l2BP3rB3t0bc4o=
X-Google-Smtp-Source: ABdhPJwIFjU5fINXJMyKsd4E84M9D0YGi3YPqyk+Ki3U6FfVmG7+iv7KFppribnBMc8vg3MNWyrVgw==
X-Received: by 2002:a17:906:e91:: with SMTP id p17mr20162604ejf.252.1595267766021;
        Mon, 20 Jul 2020 10:56:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id t2sm15750442eds.60.2020.07.20.10.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 10:56:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/2] Extend testptp with PTP perout waveform
Date:   Mon, 20 Jul 2020 20:55:57 +0300
Message-Id: <20200720175559.1234818-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrate the usage of the newly introduced flags in the
PTP_PEROUT_REQUEST2 ioctl:

https://www.spinics.net/lists/netdev/msg669346.html

Vladimir Oltean (2):
  testptp: promote 'perout' variable to int64_t
  testptp: add new options for perout phase and pulse width

 tools/testing/selftests/ptp/testptp.c | 51 ++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 8 deletions(-)

-- 
2.25.1

