Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E467572AFB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfGXJBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:01:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38189 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfGXJBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:01:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so46072482wrr.5
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 02:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ABnNRV2jnS/Vrj309T8bkU6Ol9XCOs5jJ/PoYX0KF7c=;
        b=kZypA36+Lcu8gskniBVVNPGkuSl6AWeCeM7TfY36q2+ZLDEdAcotifD53fqCejfO5G
         MXN2EqNNWTUmPJ3EZDsukgxBtW809L7LV+j4yBppQWfQb2jwVp2yjxH9oVaMqO09snWx
         isHcl1ownarme7OQUV+FqNOV35C4xsTPv2Nm5kE5r0c8h+Tz04HMifMJVay3iBwkZGYZ
         h1MrtftqZe+rBo0bGmwQSVJVMZYe9QBWirBSsGqkw7ckdr5/HmMcpuvv+YZcEKDdKOlO
         3divF8jEJ8ToYE6R4ZVaDj2YlDFBOkT/arWjDCBNTKxb6Nf8pwGUjErnWQmCCfN8JrCn
         nf+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ABnNRV2jnS/Vrj309T8bkU6Ol9XCOs5jJ/PoYX0KF7c=;
        b=Ly/s/eLLg2qxRV6C0P0GifhiwZak8aBBiN9quMoxaUGMMaHq5NsqPyOqBREtzq/rVT
         +kxvp3FwO87mGNNaUPFH7neiWzpWb7N7wVMUgPK0OFqp+UIlzDkfTzJtYVZT1uGc4vcz
         3w2+FUXZzr19W1Z8s/kGiDHfyo6hLpFTeBNzpZUKC8lTHwkGKpXCaX7vTQYnOR3UQBC0
         GDavjw0BAQoWb7Qa9gO6+ChzvOaSuN3HxdeE4rgyKA1eGM1/6o9FPy9z7s1ntUVOvDM9
         I5/MbBQnhO1aaUcppb5vGVwQrcevm+d5/2wby9KUQf8iyTZeY94kpZuzwpmJvOCHZITw
         JdaQ==
X-Gm-Message-State: APjAAAVl+59gxCrrY9tu7iBMZfbYjM7nTiy8trqUIwpvBaTDrEnziYgP
        XedcIJwq6Tpu6aQR4/fAq7I=
X-Google-Smtp-Source: APXvYqzWrZ8b02XI+2BSPK4SEkTfQzuMsvdLL7DGZXBXnlinD6Wpr07PlwB1uFXj1RBNFKtvHNlWKA==
X-Received: by 2002:adf:e843:: with SMTP id d3mr38468227wrn.249.1563958882239;
        Wed, 24 Jul 2019 02:01:22 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id c7sm38880442wro.70.2019.07.24.02.01.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 02:01:21 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:01:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 08/12] drop_monitor: Initialize timer and
 work item upon tracing enable
Message-ID: <20190724090120.GA2225@nanopsycho>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-9-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722183134.14516-9-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 22, 2019 at 08:31:30PM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>The timer and work item are currently initialized once during module
>init, but subsequent patches will need to associate different functions
>with the work item, based on the configured alert mode.
>
>Allow subsequent patches to make that change by initializing and
>de-initializing these objects during tracing enable and disable.
>
>This also guarantees that once the request to disable tracing returns,
>no more netlink notifications will be generated.
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> net/core/drop_monitor.c | 24 +++++++++++++++++++-----
> 1 file changed, 19 insertions(+), 5 deletions(-)
>
>diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
>index e68dafaaebcd..2f56a61c43c6 100644
>--- a/net/core/drop_monitor.c
>+++ b/net/core/drop_monitor.c
>@@ -257,13 +257,20 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
> 
> static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
> {
>-	int rc;
>+	int cpu, rc;
> 
> 	if (!try_module_get(THIS_MODULE)) {
> 		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
> 		return -ENODEV;
> 	}
> 
>+	for_each_possible_cpu(cpu) {
>+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
>+
>+		INIT_WORK(&data->dm_alert_work, send_dm_alert);
>+		timer_setup(&data->send_timer, sched_send_work, 0);

So don't you want to remove this initialization from
init_net_drop_monitor?


>+	}
>+
> 	rc = register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
> 	if (rc) {
> 		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to kfree_skb() tracepoint");

[...]
