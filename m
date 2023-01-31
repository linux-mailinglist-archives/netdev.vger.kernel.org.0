Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405FD68299B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjAaJxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjAaJxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:53:37 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CECC72A3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:53:27 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 143so9637619pgg.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=riWxv67vKBqRoIkEOHz2X/pq+xQjpyMXEFMcVjpkQOQ=;
        b=mGU+5V0X05Yc8sVfrVXaWC70lLeUm4WUlOH5s9uBXoxkbsLBPL+FXNqOnMx+MOCq8r
         RCufcvKnKceaS27AsKvCx0VQrXBk5R0VurRFH9gxYMs9Ek8VTbcCm7I/y9xgaOw2Z1QQ
         G+uEv94EtD+KHykOkc0u3DX3vtDkvkzRpCpi8t5CcO9omRXLtwsCjIM/Ga4WBorAKGUx
         0XWpIdc7MnZ9k8o0XEIZfL5P0rCQx0QdTrderE9bogdcdrFWuHy9fzorVy+cpDrmc1lH
         4zNnPvRLbDGcTuuu8utHgpidhUKD+QTbchbcFgBixNMMPUdvufrtDTSX8ctpMhelLUg2
         RQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=riWxv67vKBqRoIkEOHz2X/pq+xQjpyMXEFMcVjpkQOQ=;
        b=SJ0T7LVxvkpvIFP7IW1NtOlp27IEWsvAnT4zKGhJLhhkHqMAriGuzMqIJdfyvyUrKS
         DATBok/tFMM3Sh3crctY0oAnXZZzMW3+aQzbn+9Y2eQm6WEnHgBHZjM/S96fYEYoJQle
         t8uT7oa8lrI7aAApeD1M06SaRnlY6cK2HzBb+D1hZJJLaHkqCcfGKLtH+gPZIpHMT6un
         u/0BAmO98hVP6C5T1BD2+/LulpL72J0gmNtMXECmqNcaW2HpxNfJr45MhmgZ14OXxFCZ
         +XxTKuR6jfSqUL0bJD8M9fJamq87K7zYYpLN07S0i4ZDjROIsPFYawqnsMTeOGlzzdk7
         XSFQ==
X-Gm-Message-State: AO0yUKVUFRjbNaPF6GBUHgZeFTcprjg2GlK8drw2x6kEG0iDO71Dzu0n
        j5jLxSamS39c9KVngD0MV1o=
X-Google-Smtp-Source: AK7set+SLCGibhhITwGpqtPnJoxWIIl0gAEe5r0eLmbKMoMrWufZr0ahkQ3FbQT8EPqZX+hqRtDvKQ==
X-Received: by 2002:a62:f250:0:b0:593:d5de:f02c with SMTP id y16-20020a62f250000000b00593d5def02cmr4003055pfl.27.1675158806929;
        Tue, 31 Jan 2023 01:53:26 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000a0a00b00588fb6fafe0sm8941348pfh.188.2023.01.31.01.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:53:25 -0800 (PST)
Date:   Tue, 31 Jan 2023 17:53:22 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Message-ID: <Y9jlElu4Hb1ktoZi@Laptop-X1>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com>
 <20230113034617.2767057-2-liuhangbin@gmail.com>
 <20230112203019.738d9744@hermes.local>
 <CAM0EoMmw+uQuXkVZprspDbqtoQLGHEM0An0ogzD5bFdOJEqWXg@mail.gmail.com>
 <20230114090311.1adf0176@hermes.local>
 <CAM0EoMkOquxiQH23gKwehf_MGL4j2GbGDdZxW-cc8bpC6Jrpqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMkOquxiQH23gKwehf_MGL4j2GbGDdZxW-cc8bpC6Jrpqw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 10:09:41AM -0500, Jamal Hadi Salim wrote:
> > Ok, but use lower case for JSON tag following existing conventions.
> >
> > Note: json support in monitor mode is incomplete for many of the
> > commands bridge, ip, tc, devlink. It doesn't always generate valid JSON
> > yet.
> 
> We can work for starters with the tc one and maybe cover ip as well...

I tried adding the JSON obj for ip monitor. There are 2 choices and some
issues.

If we open JSON before/after accept_msg:

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 9b055264..a6944636 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -338,8 +338,13 @@ int do_ipmonitor(int argc, char **argv)
        netns_nsid_socket_init();
        netns_map_init();

-       if (rtnl_listen(&rth, accept_msg, stdout) < 0)
+       new_json_obj(json);
+       if (rtnl_listen(&rth, accept_msg, stdout) < 0) {
+               delete_json_obj();
                exit(2);
+       }
+
+       delete_json_obj();

        return 0;
 }

The JSON output looks like the following result, the ifindex is not quoted in
the braces. And the JSON format is not complete at the end.
# ip/ip -j -p monitor
[ {
        "family": "inet",
        "interface": "veth0",
        "forwarding": false,
        "rp_filter": "strict",
        "mc_forwarding": false,
        "proxy_neigh": false,
        "ignore_routes_with_linkdown": false
    },{
        "family": "inet6",
        "interface": "veth0",
        "forwarding": false,
        "mc_forwarding": false,
        "proxy_neigh": false,
        "ignore_routes_with_linkdown": false
    },
    "ifindex": 17,
    "link": null,
    "ifname": "veth0",
    "flags": [ "BROADCAST","MULTICAST" ],
    "mtu": 1500,
    "qdisc": "noop",
    "operstate": "DOWN",
    "group": "default",
    "link_type": "ether",
    "address": "72:4f:8c:32:13:63",
    "broadcast": "ff:ff:ff:ff:ff:ff",{
        "family": "inet",
        "interface": "veth1",
        "forwarding": false,
        "rp_filter": "strict",
        "mc_forwarding": false,
        "proxy_neigh": false,
        "ignore_routes_with_linkdown": false
    },{
        "family": "inet6",
        "interface": "veth1",
        "forwarding": false,
        "mc_forwarding": false,
        "proxy_neigh": false,
        "ignore_routes_with_linkdown": false
    },
    "ifindex": 18,
    "link": "veth0",
    "ifname": "veth1",
    "flags": [ "BROADCAST","MULTICAST","M-DOWN" ],
    "mtu": 1500,
    "qdisc": "noop",
    "operstate": "DOWN",
    "group": "default",
    "link_type": "ether",
    "address": "42:75:b7:38:9c:ad",
    "broadcast": "ff:ff:ff:ff:ff:ff",{
        "dst": "fe80::ee3e:f701:b990:8a61",
        "dev": "eth0",
        "lladdr": "ec:3e:f7:90:8a:61",
        "router": null,
        "state": [ "STALE" ]
    }^C


If we open JSON in the accept_msg(). Like:

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 9b055264..4af18a6c 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -55,6 +55,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 {
        FILE *fp = (FILE *)arg;

+       new_json_obj(json);
        switch (n->nlmsg_type) {
        case RTM_NEWROUTE:
        case RTM_DELROUTE: {
@@ -63,21 +64,21 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,

                if (len < 0) {
                        fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
-                       return -1;
+                       goto err_out;
                }

                if (r->rtm_flags & RTM_F_CLONED)
-                       return 0;
+                       goto out;

[...]

@@ -170,7 +171,14 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
                        n->nlmsg_flags, n->nlmsg_flags, n->nlmsg_len,
                        n->nlmsg_len);
        }
+
+out:
+       delete_json_obj();
        return 0;
+
+err_out:
+       delete_json_obj();
+       return -1;
 }

The result would like:

# ./ip/ip -j monitor
[{"deleted":true,"family":"inet","interface":"veth0"}]
[{"deleted":true,"family":"inet6","interface":"veth0"}]
[{"deleted":true,"family":"inet","interface":"veth1"}]
[{"deleted":true,"family":"inet6","interface":"veth1"}]

This format looks good, but I'm not sure if the JSON output is valid with
list for each line.

Any comments?

Thanks
Hangbin
