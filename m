Return-Path: <netdev+bounces-1257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE356FD11A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6342812CA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534F519939;
	Tue,  9 May 2023 21:23:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422E219900
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:04 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748F3D048
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6435bbedb4fso6939572b3a.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667292; x=1686259292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm92ViUAYLKqPDDAyrxZT4UsjSYgVO31cUzdYID+F4o=;
        b=EXLEOW9mkZM4JgLxBx3tMZa8J7ZM5R9cJakWjJkDz1WfyKoZLOg/UIBYdax68ej5QN
         gxCwGO60eK0zTFQ43Bjmux6DJiJT4s5goMIUK9RMPP2/iZN/WVfB6jcMF6kSwK7WzxDd
         RDoCpoJqRCLWoQmJ9dxSLyFU243qnkquSTof+0grJWD6P23aL/1Do5yVtZx+oOV36svn
         ysdmRYf6YW+DAzL6oBS2KYRiq3bSROL0vq+cLIYj52Ln45SHLXRNV7zzN88UnimO7Xns
         rCeAsJtAq4F6DxfkC9A2fhkpc+n2qCatLrIaANI35DUE8Ti62twNn0L3V6AYi1yxbgap
         jDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667292; x=1686259292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gm92ViUAYLKqPDDAyrxZT4UsjSYgVO31cUzdYID+F4o=;
        b=AVrjcTvrnDvnHgo9Uw/JeI6H/OGVqT1KHBb2lNjdcxMe8iu9BKtdft2FucoVYFGfFT
         IxdxADN8mxQ0y5Sus2cr22Pp4sn/I5VE44bEczWWu5DzqddHNRnP07dAteyVoU3+8nHo
         9/sFkvbsYq8Znfzj401/MYR92cqCuVIgzW0PibiibhcaIWjNUpVuN/1THSyJMR8Qy8xT
         7HrDxhX+1pq8+a+7FzvRhplvL4W5sr/98YrDOHejBhRf2sTjOGkFXcPYuSWJUkk/fv9q
         SuJ0NsulEqURvp/+BKwRYg5KxHQnoLoVs+1mfixGGz1/YYI9HfqMbYP4DbNRDMF+ov9W
         SJLQ==
X-Gm-Message-State: AC+VfDw5Kg0XSNklKyw7HOWqZeBqAlAvRbgfHkg5lo/4gUjIc7eUUeOU
	BlUn4rjdUXSUB8wW2i9uqJmutPdqGJ88gSSVlC3y1A==
X-Google-Smtp-Source: ACHHUZ6Vq6w2pyIf1EtvrUk6fpzdjm5I8r3RQB2GKpyWrvwehjKEr8rcgq8aNz1XYLUC1Ek+raqY1Q==
X-Received: by 2002:a05:6a00:2d25:b0:643:6b94:374b with SMTP id fa37-20020a056a002d2500b006436b94374bmr23530981pfb.1.1683667292358;
        Tue, 09 May 2023 14:21:32 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:31 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 03/11] iproute_lwtunnel: fix possible use of NULL when malloc() fails
Date: Tue,  9 May 2023 14:21:17 -0700
Message-Id: <20230509212125.15880-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509212125.15880-1-stephen@networkplumber.org>
References: <20230509212125.15880-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

iproute_lwtunnel.c: In function ‘parse_srh’:
iproute_lwtunnel.c:903:9: warning: use of possibly-NULL ‘srh’ where non-null expected [CWE-690] [-Wanalyzer-possible-null-argument]
  903 |         memset(srh, 0, srhlen);
      |         ^~~~~~~~~~~~~~~~~~~~~~
  ‘parse_srh’: events 1-2
    |
    |  902 |         srh = malloc(srhlen);
    |      |               ^~~~~~~~~~~~~~
    |      |               |
    |      |               (1) this call could return NULL
    |  903 |         memset(srh, 0, srhlen);
    |      |         ~~~~~~~~~~~~~~~~~~~~~~
    |      |         |
    |      |         (2) argument 1 (‘srh’) from (1) could be NULL where non-null expected
    |
In file included from iproute_lwtunnel.c:13:
/usr/include/string.h:61:14: note: argument 1 of ‘memset’ must be non-null
   61 | extern void *memset (void *__s, int __c, size_t __n) __THROW __nonnull ((1));
      |              ^~~~~~
iproute_lwtunnel.c: In function ‘parse_encap_seg6’:
iproute_lwtunnel.c:980:9: warning: use of possibly-NULL ‘tuninfo’ where non-null expected [CWE-690] [-Wanalyzer-possible-null-argument]
  980 |         memset(tuninfo, 0, sizeof(*tuninfo) + srhlen);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ‘parse_encap_seg6’: events 1-2
    |
    |  934 | static int parse_encap_seg6(struct rtattr *rta, size_t len, int *argcp,
    |      |            ^~~~~~~~~~~~~~~~
    |      |            |
    |      |            (1) entry to ‘parse_encap_seg6’
    |......
    |  976 |         srh = parse_srh(segbuf, hmac, encap);
    |      |               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |               |
    |      |               (2) calling ‘parse_srh’ from ‘parse_encap_seg6’
    |
    +--> ‘parse_srh’: events 3-5
           |
           |  882 | static struct ipv6_sr_hdr *parse_srh(char *segbuf, int hmac, bool encap)
           |      |                            ^~~~~~~~~
           |      |                            |
           |      |                            (3) entry to ‘parse_srh’
           |......
           |  922 |         if (hmac) {
           |      |            ~
           |      |            |
           |      |            (4) following ‘false’ branch (when ‘hmac == 0’)...
           |......
           |  931 |         return srh;
           |      |                ~~~
           |      |                |
           |      |                (5) ...to here
           |
    <------+
    |
  ‘parse_encap_seg6’: events 6-8
    |
    |  976 |         srh = parse_srh(segbuf, hmac, encap);
    |      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |               |
    |      |               (6) returning to ‘parse_encap_seg6’ from ‘parse_srh’
    |......
    |  979 |         tuninfo = malloc(sizeof(*tuninfo) + srhlen);
    |      |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                   |
    |      |                   (7) this call could return NULL
    |  980 |         memset(tuninfo, 0, sizeof(*tuninfo) + srhlen);
    |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |         |
    |      |         (8) argument 1 (‘tuninfo’) from (7) could be NULL where non-null expected
    |
/usr/include/string.h:61:14: note: argument 1 of ‘memset’ must be non-null
   61 | extern void *memset (void *__s, int __c, size_t __n) __THROW __nonnull ((1));
      |              ^~~~~~
iproute_lwtunnel.c: In function ‘parse_rpl_srh’:
iproute_lwtunnel.c:1018:21: warning: dereference of possibly-NULL ‘srh’ [CWE-690] [-Wanalyzer-possible-null-dereference]
 1018 |         srh->hdrlen = (srhlen >> 3) - 1;
      |         ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
  ‘parse_rpl_srh’: events 1-2
    |
    | 1016 |         srh = calloc(1, srhlen);
    |      |               ^~~~~~~~~~~~~~~~~
    |      |               |
    |      |               (1) this call could return NULL
    | 1017 |
    | 1018 |         srh->hdrlen = (srhlen >> 3) - 1;
    |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                     |
    |      |                     (2) ‘srh’ could be NULL: unchecked value from (1)
    |

Fixes: 00e76d4da37f ("iproute: add helper functions for SRH processing")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iproute_lwtunnel.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 308178efe054..96de3b207ef4 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -900,6 +900,9 @@ static struct ipv6_sr_hdr *parse_srh(char *segbuf, int hmac, bool encap)
 		srhlen += 40;
 
 	srh = malloc(srhlen);
+	if (srh == NULL)
+		return NULL;
+
 	memset(srh, 0, srhlen);
 
 	srh->hdrlen = (srhlen >> 3) - 1;
@@ -935,14 +938,14 @@ static int parse_encap_seg6(struct rtattr *rta, size_t len, int *argcp,
 			    char ***argvp)
 {
 	int mode_ok = 0, segs_ok = 0, hmac_ok = 0;
-	struct seg6_iptunnel_encap *tuninfo;
+	struct seg6_iptunnel_encap *tuninfo = NULL;
 	struct ipv6_sr_hdr *srh;
 	char **argv = *argvp;
 	char segbuf[1024] = "";
 	int argc = *argcp;
 	int encap = -1;
 	__u32 hmac = 0;
-	int ret = 0;
+	int ret = -1;
 	int srhlen;
 
 	while (argc > 0) {
@@ -974,9 +977,13 @@ static int parse_encap_seg6(struct rtattr *rta, size_t len, int *argcp,
 	}
 
 	srh = parse_srh(segbuf, hmac, encap);
+	if (srh == NULL)
+		goto out;
 	srhlen = (srh->hdrlen + 1) << 3;
 
 	tuninfo = malloc(sizeof(*tuninfo) + srhlen);
+	if (tuninfo == NULL)
+		goto out;
 	memset(tuninfo, 0, sizeof(*tuninfo) + srhlen);
 
 	tuninfo->mode = encap;
@@ -984,13 +991,12 @@ static int parse_encap_seg6(struct rtattr *rta, size_t len, int *argcp,
 	memcpy(tuninfo->srh, srh, srhlen);
 
 	if (rta_addattr_l(rta, len, SEG6_IPTUNNEL_SRH, tuninfo,
-			  sizeof(*tuninfo) + srhlen)) {
-		ret = -1;
+			  sizeof(*tuninfo) + srhlen))
 		goto out;
-	}
 
 	*argcp = argc + 1;
 	*argvp = argv - 1;
+	ret = 0;
 
 out:
 	free(tuninfo);
@@ -1014,6 +1020,8 @@ static struct ipv6_rpl_sr_hdr *parse_rpl_srh(char *segbuf)
 	srhlen = 8 + 16 * nsegs;
 
 	srh = calloc(1, srhlen);
+	if (srh == NULL)
+		return NULL;
 
 	srh->hdrlen = (srhlen >> 3) - 1;
 	srh->type = 3;
-- 
2.39.2


