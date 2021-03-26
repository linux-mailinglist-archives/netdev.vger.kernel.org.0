Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DF234A5CD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhCZKtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:49:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51825 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhCZKtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:49:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9FFA75C14DD
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:49:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Mar 2021 06:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=g3hZHxLzn2ulW9ihpuUJr6or9L
        NEkKTtgdkUxo7ws3I=; b=0bNoVPdvB1MdpE1sBY5CogHF/m/1JhrkRj8GE5v2z+
        VGa5P5gZJPVZg0hTO1G0Wf2pNO1cYFilZIQz/dUbNWkXr3sv64h08XlsESpXcWoe
        eFU7YsxnYg62C0t55e37Hm4wpnRkK5Z2HGeVbBpCun+TNfLI7dssFwyhmGZF8YV4
        By3vjXJSXPzqsTBX3nchN1F116jjv2R4SchmOMB/jC/DE0yylIUfMFoPvt4klDkJ
        nWEnP0k2k5frBMy/Vw+A5C1cTIQtzO9tt3ljyuph2v35rusHJsq6FowgK2nrUJsO
        8XJ+7gjPDLskxRK8Qd/gL/TwF0mBdUWPkxAHu2O+sJrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g3hZHx
        Lzn2ulW9ihpuUJr6or9LNEkKTtgdkUxo7ws3I=; b=AOSLEHvfs9xzLHDllsjpGd
        fKNuMAuVkIzZfu6aI/jqZXHfODmxHBpZbx5L73gg3RnHT64nYauaJepkVYTzpm+O
        UijnmQ1v2iI9pj1PsEOd3sfuFbLtDQ2T1eiCDmbZI4YKwkqFNSZgUUESxkgmKBED
        61kdgvjeMBQjUzS0nGeO7Pmoc4M5zibpMVBLkWS71uKh45MDl4YhLHdUqHft1uVJ
        nbpc96bD7fhzDqBFa0qI5+fou6VAlzUwsDbnyZCnaAOUHx9dcbIMaVVHOlOc41F6
        l9FrFnM7zEdZ4xFRVRee9p8eFij/RRMh3qorsyYk169XJ1JMXSHpS/tCmlYaxT4Q
        ==
X-ME-Sender: <xms:PLxdYPP2o-WaPoKmbTLPXTYQ9GTPQolNbqWmR_roE_hArB_EMmEkDw>
    <xme:PLxdYJ-TqMCD9JR5-gyuA0bJ4Ru9hXIyyJkfv_Dk0n6ZJ_cS5VyOi4D8gdEGUpd6_
    o-WWi8fMgE7oJVYwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgovfgvgihtqfhnlhihqddqteefjeefqddtgeculd
    ehtddmnecujfgurhepkffuhffvffgtfggggfesthejredttderjeenucfhrhhomhepvehh
    rhhishhtohhphhgvrhcuvfgrlhgsohhtuceotghhrhhishesthgrlhgsohhthhhomhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpeejudehtdelfffhkedvudelteeffeefgfeugfdu
    vdeltdefheeghfdvgfeijeevhfenucffohhmrghinhepshhrrdhhthenucfkphepjedvrd
    elhedrvdegfedrudehieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegthhhrihhssehtrghlsghothhhohhmvgdrtghomh
X-ME-Proxy: <xmx:PLxdYOQMXGxLhWQ19-gpI7v-DPdQi2giPDsr5tZgjUbhu0x__GSPYQ>
    <xmx:PLxdYDvB2bWpNvKqh9KaByJFxvbxw-1HMm0QXHqfpPytM2owHFIjSw>
    <xmx:PLxdYHcM-pnAnMC2BTqvAnohI26KKx9jsEnitmv4oPooeKHgkEs-qw>
    <xmx:PLxdYBot85q62dGdbcxOjeIPYrbawgXpmwiOfCTBGWcbMAzS0WtoRw>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53D06240066
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:49:32 -0400 (EDT)
Message-ID: <dd7950f6df08d5ad50f91c6431ef46298b505738.camel@talbothome.com>
Subject: [PATCH 1/9] Fix mmsd to work with T-mobile
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:49:31 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch is based off of anteater's patch to enable T-Mobile (
https://git.sr.ht/~anteater/mmsd), but fixes a couple of hacks
that were in it

---
 Makefile.am       |   3 +-
 gweb/gresolv.c    |  73 ++++++++++++++-
 gweb/gweb.c       |   1 +
 plugins/ofono.c   |  11 ++-
 src/mmsutil.c     | 233 ++++++++++++++++++++++++++++++++++++++--------
 src/mmsutil.h     |  17 ++++
 src/service.c     |  58 ++++++++++--
 test/send-message |  24 ++---
 8 files changed, 356 insertions(+), 64 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index ee2c715..99fdb76 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -88,7 +88,8 @@ unit_test_wsputil_SOURCES = unit/test-wsputil.c
src/wsputil.c src/wsputil.h
 unit_test_wsputil_LDADD = @GLIB_LIBS@
 
 unit_test_mmsutil_SOURCES = unit/test-mmsutil.c src/mmsutil.c
src/mmsutil.h \
-                                               src/wsputil.c
src/wsputil.h
+                                               src/wsputil.c
src/wsputil.h \
+                                               src/log.c src/log.h
 unit_test_mmsutil_LDADD = @GLIB_LIBS@
 
 TESTS = unit/test-wsputil unit/test-mmsutil
diff --git a/gweb/gresolv.c b/gweb/gresolv.c
index 79abc9b..bb1c32d 100644
--- a/gweb/gresolv.c
+++ b/gweb/gresolv.c
@@ -35,6 +35,7 @@
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
 #include <net/if.h>
+#include <ifaddrs.h>
 
 #include "gresolv.h"
 
@@ -764,13 +765,15 @@ static int connect_udp_channel(struct
resolv_nameserver *nameserver)
                return -EINVAL;
 
        sk = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
+       const int so_reuseaddr = 1;
+       setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &so_reuseaddr, sizeof
so_reuseaddr);
        if (sk < 0) {
                freeaddrinfo(rp);
                return -EIO;
        }
 
        /*
-        * If nameserver points to localhost ip, their is no need to
+        * If nameserver points to localhost ip, there is no need to
         * bind the socket on any interface.
         */
        if (nameserver->resolv->index > 0 &&
@@ -780,12 +783,63 @@ static int connect_udp_channel(struct
resolv_nameserver *nameserver)
                memset(interface, 0, IF_NAMESIZE);
                if (if_indextoname(nameserver->resolv->index,
                                                interface) != NULL) {
-                       if (setsockopt(sk, SOL_SOCKET, SO_BINDTODEVICE,
-                                               interface, IF_NAMESIZE)
< 0) {
+                       /* set up bind address */
+                       struct sockaddr_storage bind_addr;
+                       int addr_size = 0;
+                       memset(&bind_addr, 0, sizeof(bind_addr));
+                       bind_addr.ss_family = rp->ai_family;
+
+                       struct ifaddrs *ifa, *ifa_tmp;
+                       if (getifaddrs(&ifa) == -1) {
+                               perror("getifaddrs failed");
+                               return -errno;
+                       }
+                       ifa_tmp = ifa;
+                       while (ifa_tmp) {
+                               if (!strcmp(ifa_tmp->ifa_name,
interface) && 
+                                               ifa_tmp->ifa_addr) {
+                                       if (ifa_tmp->ifa_addr-
>sa_family != rp->ai_family) {
+                                               printf("fam %d !=
expected %d\n", ifa_tmp->ifa_addr->sa_family, rp->ai_family);
+                                               ifa_tmp = ifa_tmp-
>ifa_next;
+                                               continue;
+                                       }
+                                       if (ifa_tmp->ifa_addr-
>sa_family == AF_INET) {
+                                               struct sockaddr_in
*bind_addr4 = (struct sockaddr_in *)&bind_addr;
+                                               bind_addr4-
>sin_addr.s_addr = ((struct sockaddr_in *)ifa_tmp->ifa_addr)-
>sin_addr.s_addr;
+                                               bind_addr4->sin_port =
53;
+                                               printf("addr = %s\n",
inet_ntoa(bind_addr4->sin_addr));
+                                               addr_size =
sizeof(*bind_addr4);
+                                       } else if (ifa_tmp->ifa_addr-
>sa_family == AF_INET6) {
+                                               struct sockaddr_in6
*bind_addr6 = (struct sockaddr_in6 *)&bind_addr;
+                                               bind_addr6->sin6_addr =
((struct sockaddr_in6 *)ifa_tmp->ifa_addr)->sin6_addr;
+                                               bind_addr6->sin6_port =
53;
+                                               char buf[64];
+                                               inet_ntop(AF_INET6,
bind_addr6->sin6_addr.s6_addr, buf, 64);
+                                               printf("addr = %s\n",
buf);
+                                               addr_size =
sizeof(*bind_addr6);
+                                       } else {
+                                               printf("unknown
fam\n");
+                                       }
+                                       break;
+                               }
+                               ifa_tmp = ifa_tmp->ifa_next;
+                       }
+
+/*                     if (bind_addr. && bind_addr.sin_addr.s_addr ==
0) {
+                               printf("interface not found\n");
+                       }
+
+                       if (bind_addr.sin6_addr.s_addr == 0) {
+                               printf("interface6 not found\n");
+                       }*/
+
+                       if (bind(sk, (struct sockaddr *)&bind_addr,
addr_size) < 0) {
+                               perror("bind failed");
                                close(sk);
                                freeaddrinfo(rp);
                                return -EIO;
                        }
+                       freeifaddrs(ifa);
                }
        }
 
@@ -896,6 +950,7 @@ void g_resolv_set_debug(GResolv *resolv,
GResolvDebugFunc func,
 gboolean g_resolv_add_nameserver(GResolv *resolv, const char *address,
                                        uint16_t port, unsigned long
flags)
 {
+       printf ("adding nameserver %s\n", address);
        struct resolv_nameserver *nameserver;
 
        if (resolv == NULL)
@@ -911,6 +966,7 @@ gboolean g_resolv_add_nameserver(GResolv *resolv,
const char *address,
        nameserver->resolv = resolv;
 
        if (connect_udp_channel(nameserver) < 0) {
+               printf ("connect_udp_channel failed!\n");
                free_nameserver(nameserver);
                return FALSE;
        }
@@ -977,6 +1033,9 @@ guint g_resolv_lookup_hostname(GResolv *resolv,
const char *hostname,
 
        if (resolv->nameserver_list == NULL) {
                int i;
+               printf("g_resolv_lookup_hostname: nameserver_list
NULL\n");
+
+               printf("g_resolv_lookup_hostname: nscount=%d\n",
resolv->res.nscount);
 
                for (i = 0; i < resolv->res.nscount; i++) {
                        char buf[100];
@@ -989,15 +1048,19 @@ guint g_resolv_lookup_hostname(GResolv *resolv,
const char *hostname,
                                sa_addr = &resolv-
>res._u._ext.nsaddrs[i]->sin6_addr;
                        }
 
-                       if (family != AF_INET && family != AF_INET6)
+                       if (family != AF_INET && family != AF_INET6) {
+                               printf("g_resolv_lookup_hostname:
skipping b/c family=%d\n", family);
                                continue;
+                       }
 
                        if (inet_ntop(family, sa_addr, buf,
sizeof(buf)))
                                g_resolv_add_nameserver(resolv, buf,
53, 0);
                }
 
-               if (resolv->nameserver_list == NULL)
+               if (resolv->nameserver_list == NULL) {
+                       printf("g_resolv_lookup_hostname:
nameserver_list *still* NULL\n");
                        g_resolv_add_nameserver(resolv, "127.0.0.1",
53, 0);
+               }
        }
 
        lookup = g_try_new0(struct resolv_lookup, 1);
diff --git a/gweb/gweb.c b/gweb/gweb.c
index 4c2f95c..f72e137 100644
--- a/gweb/gweb.c
+++ b/gweb/gweb.c
@@ -1008,6 +1008,7 @@ static inline int bind_socket(int sk, int index,
int family)
        if (if_indextoname(index, interface) == NULL)
                return -1;
 
+       printf("binding %s\n", interface);
        err = setsockopt(sk, SOL_SOCKET, SO_BINDTODEVICE,
                                        interface, IF_NAMESIZE);
        if (err < 0)
diff --git a/plugins/ofono.c b/plugins/ofono.c
index e7324a7..24a147a 100644
--- a/plugins/ofono.c
+++ b/plugins/ofono.c
@@ -396,11 +396,14 @@ static void check_context_active(struct
modem_data *modem,
                g_free(modem->context_proxy);
                modem->context_proxy = NULL;
 
+               DBG("context_active = false");
                mms_service_bearer_notify(modem->service, FALSE, NULL,
NULL);
-       } else if (modem->context_proxy != NULL)
+       } else if (modem->context_proxy != NULL) {
+               DBG("nonnull proxy");
                mms_service_bearer_notify(modem->service, TRUE,
                                                modem-
>context_interface,
                                                modem->context_proxy);
+       }
 }
 
 static void check_context_settings(struct modem_data *modem,
@@ -452,6 +455,7 @@ static void check_context_settings(struct
modem_data *modem,
        if (modem->context_active == FALSE)
                return;
 
+       DBG("about to bearer_notify");
        mms_service_bearer_notify(modem->service, TRUE,
                                        modem->context_interface,
                                        modem->context_proxy);
@@ -692,6 +696,7 @@ static void set_context_reply(DBusPendingCall
*call, void *user_data)
        dbus_error_init(&err);
 
        if (dbus_set_error_from_message(&err, reply) == TRUE) {
+               DBG("set_ctx reply failure (%s: %s), about to
bearer_notify", err.name, err.message);
                dbus_error_free(&err);
                mms_service_bearer_notify(modem->service, FALSE, NULL,
NULL);
        }
@@ -739,15 +744,17 @@ static void bearer_handler(mms_bool_t active,
void *user_data)
 {
        struct modem_data *modem = user_data;
 
-       DBG("path %s active %d", modem->path, active);
+       DBG("path %s active %d context_active %d", modem->path, active,
modem->context_active);
 
        if (active == TRUE && modem->context_active == TRUE) {
+               DBG("active and context_active, bearer_notify");
                mms_service_bearer_notify(modem->service, TRUE,
                                                modem-
>context_interface,
                                                modem->context_proxy);
                return;
        }
 
+       DBG("checking for failure");
        if (active == FALSE && modem->context_active == FALSE) {
                mms_service_bearer_notify(modem->service, FALSE, NULL,
NULL);
                return;
diff --git a/src/mmsutil.c b/src/mmsutil.c
index a9a12eb..5fcf358 100644
--- a/src/mmsutil.c
+++ b/src/mmsutil.c
@@ -32,6 +32,7 @@
 
 #include "wsputil.h"
 #include "mmsutil.h"
+#include "mms.h"
 
 #define MAX_ENC_VALUE_BYTES 6
 
@@ -75,7 +76,11 @@ enum mms_header {
        MMS_HEADER_SUBJECT =                    0x16,
        MMS_HEADER_TO =                         0x17,
        MMS_HEADER_TRANSACTION_ID =             0x18,
-       __MMS_HEADER_MAX =                      0x19,
+       MMS_HEADER_RETRIEVE_STATUS =            0x19,
+       MMS_HEADER_RETRIEVE_TEXT =              0x20,
+       MMS_HEADER_READ_STATUS =                0x21,
+       MMS_HEADER_LAST_HANDLED =               0x21,
+       __MMS_HEADER_MAX =                      0x22,
        MMS_HEADER_INVALID =                    0x80,
 };
 
@@ -159,13 +164,18 @@ static gboolean extract_short(struct
wsp_header_iter *iter, void *user)
 static const char *decode_text(struct wsp_header_iter *iter)
 {
        const unsigned char *p;
-       unsigned int l;
+       unsigned int l=32;
 
-       if (wsp_header_iter_get_val_type(iter) != WSP_VALUE_TYPE_TEXT)
+       if (wsp_header_iter_get_val_type(iter) != WSP_VALUE_TYPE_TEXT)
{
+               p = wsp_header_iter_get_val(iter);
+               DBG("could not decode text of (dummy) length %u: %*s",
l-1, l-1, p+1);
                return NULL;
+       }
 
        p = wsp_header_iter_get_val(iter);
        l = wsp_header_iter_get_val_len(iter);
+       DBG("claimed len: %u", l);
+       DBG("val: %*s", l - 1, p);
 
        return wsp_decode_text(p, l, NULL);
 }
@@ -184,31 +194,14 @@ static gboolean extract_text(struct
wsp_header_iter *iter, void *user)
        return TRUE;
 }
 
-static gboolean extract_text_array_element(struct wsp_header_iter
*iter,
-                                               void *user)
-{
-       char **out = user;
-       const char *element;
-       char *tmp;
-
-       element = decode_text(iter);
-       if (element == NULL)
-               return FALSE;
-
-       if (*out == NULL) {
-               *out = g_strdup(element);
-               return TRUE;
-       }
-
-       tmp = g_strjoin(",", *out, element, NULL);
-       if (tmp == NULL)
-               return FALSE;
-
-       g_free(*out);
-
-       *out = tmp;
-
-       return TRUE;
+static char* remove_address_type_suffix(const char* addr, size_t len)
{
+       return g_strdup(addr);
+/*     #define MMS_ADDR_SUFFIX_PUBLIC_LAND_MOBILE_NUMBER "/TYPE=PLMN"
+       if(g_str_has_suffix(addr,
MMS_ADDR_SUFFIX_PUBLIC_LAND_MOBILE_NUMBER)) {
+               return g_strndup(addr, len -
strlen(MMS_ADDR_SUFFIX_PUBLIC_LAND_MOBILE_NUMBER));
+       } else {
+               return g_strdup(addr);
+       }*/
 }
 
 static char *decode_encoded_string_with_mib_enum(const unsigned char
*p,
@@ -242,6 +235,57 @@ static char
*decode_encoded_string_with_mib_enum(const unsigned char *p,
                        &bytes_read, &bytes_written, NULL);
 }
 
+static gboolean extract_text_array_element(struct wsp_header_iter
*iter,
+                                               void *user)
+{
+       char **out = user;
+       const char *element = NULL;
+       char *tmp;
+       DBG("");
+
+       const unsigned char *p;
+       unsigned int l;
+
+       p = wsp_header_iter_get_val(iter);
+       l = wsp_header_iter_get_val_len(iter);
+
+       switch (wsp_header_iter_get_val_type(iter)) {
+       case WSP_VALUE_TYPE_TEXT:
+               /* Text-string */
+               element = wsp_decode_text(p, l, NULL);
+               break;
+       case WSP_VALUE_TYPE_LONG:
+               /* (Value-len) Char-set Text-string */
+               element = decode_encoded_string_with_mib_enum(p, l);
+               break;
+       case WSP_VALUE_TYPE_SHORT:
+               element = NULL;
+               break;
+       }
+
+       if (element == NULL) {
+               DBG("failed, type=%d",
wsp_header_iter_get_val_type(iter));
+               return FALSE;
+       }
+
+       if (*out == NULL) {
+               *out = g_strdup(element);
+               return TRUE;
+       }
+
+       tmp = g_strjoin(",", *out, element, NULL);
+       if (tmp == NULL) {
+               DBG("join failed");
+               return FALSE;
+       }
+
+       g_free(*out);
+
+       *out = tmp;
+
+       return TRUE;
+}
+
 static gboolean extract_encoded_text(struct wsp_header_iter *iter,
void *user)
 {
        char **out = user;
@@ -361,26 +405,62 @@ static gboolean extract_from(struct
wsp_header_iter *iter, void *user)
        const unsigned char *p;
        unsigned int l;
        const char *text;
+       unsigned char char_set = 0;
 
-       if (wsp_header_iter_get_val_type(iter) != WSP_VALUE_TYPE_LONG)
+       if (wsp_header_iter_get_val_type(iter) != WSP_VALUE_TYPE_LONG)
{
+               DBG("val_type not LONG");
                return FALSE;
+       }
 
        p = wsp_header_iter_get_val(iter);
        l = wsp_header_iter_get_val_len(iter);
 
-       if (p[0] != 128 && p[0] != 129)
+       /* From-value = Value-length (Address-present-token=128
Encoded-string-value | Insert-address-token=129) */
+       /* Encoded-string-value = Text-string | Value-length Char-set
Text-string */
+       /* Value-length = Short-length | (Length-quote Length) */
+       /* Short-length = val 0-30 */
+       /* Length-quote = val 31 */
+       /* Length = Uintvar-integer */
+
+       if (p[0] != 128 && p[0] != 129) {
+               DBG("not 128 or 129");
                return FALSE;
+       }
 
        if (p[0] == 129) {
                *out = NULL;
                return TRUE;
        }
+       p += 1; l -= 1; /* token has been handled */
+
+       unsigned int val_len = l;
+       unsigned int str_len;
+       if (p[0] < 31) { /*short-length */
+               val_len = p[0];
+               char_set = p[1];
+               p += 2;
+               val_len -= 1; /* count encoding against val_len */
+       } else if (p[0] == 31) /* length quote then long length */ {
+               unsigned int consumed = 0;
+               gboolean ok = wsp_decode_uintvar(p, l, &val_len,
&consumed);
+               if (!ok)
+                       return FALSE;
+               char_set = p[1];
+               p += consumed;
+               val_len -= 1; /* count encoding against val_len */
+       }
+       str_len = val_len - 1; /* NUL at the end is not counted by
strlen() */
+       
+       DBG("trying to decode text of length %u: %*s", str_len,
str_len, p);
+       text = wsp_decode_text(p, val_len, NULL);
+       DBG("text=\"%s\"", text);
 
-       text = wsp_decode_text(p + 1, l - 1, NULL);
-       if (text == NULL)
+       if (text == NULL) {
+               DBG("could not decode text of length %u: %*s", str_len,
str_len, p);
                return FALSE;
+       }
 
-       *out = g_strdup(text);
+       *out = remove_address_type_suffix(text, str_len);
 
        return TRUE;
 }
@@ -473,6 +553,50 @@ static gboolean extract_priority(struct
wsp_header_iter *iter, void *user)
        return TRUE;
 }
 
+static gboolean extract_read_status(struct wsp_header_iter *iter, void
*user)
+{
+       enum mms_message_read_status *out = user;
+       const unsigned char *p;
+
+       if (wsp_header_iter_get_val_type(iter) != WSP_VALUE_TYPE_SHORT)
+               return FALSE;
+
+       p = wsp_header_iter_get_val(iter);
+
+       if (p[0] == MMS_MESSAGE_READ_STATUS_READ ||
+               p[0] == MMS_MESSAGE_READ_STATUS_DELETED_UNREAD) {
+               *out = p[0];
+               return TRUE;
+       }
+
+       return FALSE;
+}
+
+static gboolean extract_retr_status(struct wsp_header_iter *iter, void
*user)
+{
+       enum mms_message_retr_status *out = user;
+       const unsigned char *p;
+
+       if (wsp_header_iter_get_val_type(iter) != WSP_VALUE_TYPE_SHORT)
+               return FALSE;
+
+       p = wsp_header_iter_get_val(iter);
+
+       switch (p[0]) {
+       case MMS_MESSAGE_RETR_STATUS_OK:
+       case MMS_MESSAGE_RETR_STATUS_ERR_TRANS_FAILURE:
+       case MMS_MESSAGE_RETR_STATUS_ERR_TRANS_MESSAGE_NOT_FOUND:
+       case MMS_MESSAGE_RETR_STATUS_ERR_PERM_FAILURE:
+       case MMS_MESSAGE_RETR_STATUS_ERR_PERM_SERVICE_DENIED:
+       case MMS_MESSAGE_RETR_STATUS_ERR_PERM_MESSAGE_NOT_FOUND:
+       case MMS_MESSAGE_RETR_STATUS_ERR_PERM_CONTENT_UNSUPPORTED:
+               *out = p[0];
+               return TRUE;
+       }
+
+       return FALSE;
+}
+
 static gboolean extract_rsp_status(struct wsp_header_iter *iter, void
*user)
 {
        unsigned char *out = user;
@@ -559,7 +683,7 @@ static header_handler handler_for_type(enum
mms_header header)
        case MMS_HEADER_CONTENT_LOCATION:
                return extract_text;
        case MMS_HEADER_CONTENT_TYPE:
-               return extract_text;
+               return extract_text; /* extract_encoded_text? */
        case MMS_HEADER_DATE:
                return extract_date;
        case MMS_HEADER_DELIVERY_REPORT:
@@ -590,6 +714,12 @@ static header_handler handler_for_type(enum
mms_header header)
                return extract_rsp_status;
        case MMS_HEADER_RESPONSE_TEXT:
                return extract_encoded_text;
+       case MMS_HEADER_RETRIEVE_STATUS:
+               return extract_retr_status;
+       case MMS_HEADER_RETRIEVE_TEXT:
+               return extract_encoded_text;
+       case MMS_HEADER_READ_STATUS:
+               return extract_read_status;
        case MMS_HEADER_SENDER_VISIBILITY:
                return extract_sender_visibility;
        case MMS_HEADER_STATUS:
@@ -650,8 +780,12 @@ static gboolean mms_parse_headers(struct
wsp_header_iter *iter,
                h = p[0] & 0x7f;
 
                handler = handler_for_type(h);
-               if (handler == NULL)
+               if (handler == NULL) {
+                       DBG("no handler for type %u", h);
                        return FALSE;
+               }
+
+               DBG("saw header of type %u", h);
 
                /* Unsupported header, skip */
                if (entries[h].data == NULL)
@@ -662,9 +796,15 @@ static gboolean mms_parse_headers(struct
wsp_header_iter *iter,
                                !(entries[h].flags &
HEADER_FLAG_ALLOW_MULTI))
                        continue;
 
+               DBG("running handler for type %u", h);
+
                /* Parse the header */
-               if (handler(iter, entries[h].data) == FALSE)
+               if (handler(iter, entries[h].data) == FALSE) {
+                       DBG("handler %p for type %u returned false",
handler, h);
                        return FALSE;
+               }
+
+               DBG("handler for type %u was success", h);
 
                entries[h].pos = i;
                entries[h].flags |= HEADER_FLAG_MARKED;
@@ -672,8 +812,10 @@ static gboolean mms_parse_headers(struct
wsp_header_iter *iter,
 
        for (i = 0; i < __MMS_HEADER_MAX + 1; i++) {
                if ((entries[i].flags & HEADER_FLAG_MANDATORY) &&
-                               !(entries[i].flags &
HEADER_FLAG_MARKED))
+                               !(entries[i].flags &
HEADER_FLAG_MARKED)) {
+                       DBG("header %u was mandatory but not marked",
i);
                        return FALSE;
+               }
        }
 
        /*
@@ -704,8 +846,10 @@ static gboolean mms_parse_headers(struct
wsp_header_iter *iter,
 
                va_end(args);
 
-               if (entries[i].pos != expected_pos)
+               if (entries[i].pos != expected_pos) {
+                       DBG("header %u was in position %u but expected
in position %u", i, entries[i].pos, expected_pos);
                        return FALSE;
+               }
        }
 
        return TRUE;
@@ -770,6 +914,7 @@ static gboolean extract_content_id(struct
wsp_header_iter *iter, void *user)
                return FALSE;
 
        *out = g_strdup(text);
+       DBG("extracted content-id %s\n", *out);
 
        return TRUE;
 }
@@ -991,11 +1136,17 @@ gboolean mms_message_decode(const unsigned char
*pdu,
        flags |= WSP_HEADER_ITER_FLAG_DETECT_MMS_MULTIPART;
        wsp_header_iter_init(&iter, pdu, len, flags);
 
+       DBG("about to check well known");
+
        CHECK_WELL_KNOWN_HDR(MMS_HEADER_MESSAGE_TYPE);
 
+       DBG("about to extract short");
+
        if (extract_short(&iter, &octet) == FALSE)
                return FALSE;
 
+       DBG("octet %u", octet);
+
        if (octet < MMS_MESSAGE_TYPE_SEND_REQ ||
                        octet > MMS_MESSAGE_TYPE_DELIVERY_IND)
                return FALSE;
@@ -1422,6 +1573,12 @@ static header_encoder encoder_for_type(enum
mms_header header)
                return NULL;
        case MMS_HEADER_RESPONSE_TEXT:
                return NULL;
+       case MMS_HEADER_RETRIEVE_STATUS:
+               return NULL;
+       case MMS_HEADER_RETRIEVE_TEXT:
+               return NULL;
+       case MMS_HEADER_READ_STATUS:
+               return NULL;
        case MMS_HEADER_SENDER_VISIBILITY:
                return NULL;
        case MMS_HEADER_STATUS:
diff --git a/src/mmsutil.h b/src/mmsutil.h
index e32c761..00ecc39 100644
--- a/src/mmsutil.h
+++ b/src/mmsutil.h
@@ -50,6 +50,23 @@ enum mms_message_rsp_status {
        MMS_MESSAGE_RSP_STATUS_ERR_PERM_LACK_OF_PREPAID
=               
235,
 };
 
+enum mms_message_retr_status {
+       MMS_MESSAGE_RETR_STATUS_OK =                            128,
+       MMS_MESSAGE_RETR_STATUS_ERR_TRANS_MIN =                 192,
+       MMS_MESSAGE_RETR_STATUS_ERR_TRANS_FAILURE =             192,
+       MMS_MESSAGE_RETR_STATUS_ERR_TRANS_MESSAGE_NOT_FOUND =   194,
+       MMS_MESSAGE_RETR_STATUS_ERR_PERM_MIN =                  224,
+       MMS_MESSAGE_RETR_STATUS_ERR_PERM_FAILURE =              224,
+       MMS_MESSAGE_RETR_STATUS_ERR_PERM_SERVICE_DENIED =       225,
+       MMS_MESSAGE_RETR_STATUS_ERR_PERM_MESSAGE_NOT_FOUND =    226,
+       MMS_MESSAGE_RETR_STATUS_ERR_PERM_CONTENT_UNSUPPORTED =  227,
+};
+
+enum mms_message_read_status {
+       MMS_MESSAGE_READ_STATUS_READ =                  128,
+       MMS_MESSAGE_READ_STATUS_DELETED_UNREAD =        129,
+};
+
 enum mms_message_notify_status {
        MMS_MESSAGE_NOTIFY_STATUS_RETRIEVED =           129,
        MMS_MESSAGE_NOTIFY_STATUS_REJECTED =            130,
diff --git a/src/service.c b/src/service.c
index b3ecc1e..c7ef255 100644
--- a/src/service.c
+++ b/src/service.c
@@ -609,7 +609,7 @@ static void emit_message_added(const struct
mms_service *service,
 
 static void activate_bearer(struct mms_service *service)
 {
-       DBG("service %p", service);
+       DBG("service %p setup %d active %d", service, service-
>bearer_setup, service->bearer_active);
 
        if (service->bearer_setup == TRUE)
                return;
@@ -622,7 +622,7 @@ static void activate_bearer(struct mms_service
*service)
        if (service->bearer_handler == NULL)
                return;
 
-       DBG("service %p", service);
+       DBG("service %p waiting for %d seconds", service,
BEARER_SETUP_TIMEOUT);
 
        service->bearer_setup = TRUE;
 
@@ -736,6 +736,8 @@ static DBusMessage *get_messages(DBusConnection
*conn,
        GHashTableIter table_iter;
        gpointer key, value;
 
+       DBG("");
+
        reply = dbus_message_new_method_return(dbus_msg);
        if (reply == NULL)
                return NULL;
@@ -1632,6 +1634,7 @@ static void append_attachment_properties(struct
mms_attachment *part,
        dbus_message_iter_open_container(part_array, DBUS_TYPE_STRUCT,
                                                        NULL, &entry);
 
+       DBG("content-id: %s\n", part->content_id);
        dbus_message_iter_append_basic(&entry, DBUS_TYPE_STRING,
                                                        &part-
>content_id);
        dbus_message_iter_append_basic(&entry, DBUS_TYPE_STRING,
@@ -1793,7 +1796,7 @@ static void append_msg_recipients(DBusMessageIter
*dict,
 
        for (i = 0; tokens[i] != NULL; i++) {
                rcpt = mms_address_to_string(tokens[i]);
-
+               DBG("rcpt=%s", rcpt);
                dbus_message_iter_append_basic(&array,
DBUS_TYPE_STRING, &rcpt);
        }
 
@@ -1814,25 +1817,31 @@ static void
append_rc_msg_properties(DBusMessageIter *dict,
        const char *from_prefix;
        char *from;
 
+       DBG("status=%s", status);
        mms_dbus_dict_append_basic(dict, "Status",
                                        DBUS_TYPE_STRING, &status);
 
+       DBG("date=%s", date);
        mms_dbus_dict_append_basic(dict, "Date",
                                        DBUS_TYPE_STRING,  &date);
 
+       DBG("subject=%s", msg->rc.subject);
        if (msg->rc.subject != NULL)
                mms_dbus_dict_append_basic(dict, "Subject",
                                        DBUS_TYPE_STRING, &msg-
>rc.subject);
 
+       DBG("from=%s", msg->rc.from);
        from = g_strdup(msg->rc.from);
 
        if (from != NULL) {
                from_prefix = mms_address_to_string(from);
+               DBG("from_pfx=%s", from_prefix);
                mms_dbus_dict_append_basic(dict, "Sender",
                                        DBUS_TYPE_STRING,
&from_prefix);
                g_free(from);
        }
 
+       DBG("to=%s", msg->rc.to);
        if (msg->rc.to != NULL)
                append_msg_recipients(dict, msg);
 }
@@ -1862,6 +1871,8 @@ static void append_message(const char *path,
const struct mms_service *service,
 
        mms_dbus_dict_open(iter, &dict);
 
+       DBG("type=%d", msg->type);
+
        switch (msg->type) {
        case MMS_MESSAGE_TYPE_SEND_REQ:
                append_sr_msg_properties(&dict, msg);
@@ -1873,7 +1884,7 @@ static void append_message(const char *path,
const struct mms_service *service,
        case MMS_MESSAGE_TYPE_NOTIFYRESP_IND:
                break;
        case MMS_MESSAGE_TYPE_RETRIEVE_CONF:
-               append_rc_msg_properties(&dict, msg);
+               append_rc_msg_properties(&dict, msg); /* causes dbus
disconnect! */
                break;
        case MMS_MESSAGE_TYPE_ACKNOWLEDGE_IND:
                break;
@@ -1884,6 +1895,7 @@ static void append_message(const char *path,
const struct mms_service *service,
        if (msg->attachments != NULL) {
                char *pdu_path = mms_store_get_path(service->identity,
                                                                msg-
>uuid);
+               DBG("appending pdu path %s", pdu_path);
                append_msg_attachments(&dict, pdu_path, msg);
                g_free(pdu_path);
        }
@@ -2059,8 +2071,10 @@ static gboolean
result_request_notify_resp(struct mms_request *request)
                return FALSE;
        }
 
-       if (request->msg == NULL)
+       if (request->msg == NULL) {
+               mms_error("POST m.notify.resp.ind provided no message
to register");
                return FALSE;
+       }
 
        msg = mms_request_steal_message(request);
 
@@ -2210,6 +2224,9 @@ static gboolean web_get_cb(GWebResult *result,
gpointer user_data)
 complete:
        close(request->fd);
 
+       DBG("request->result_cb=%p vs.
retrieve_conf=%p/send_conf=%p/notify_resp=%p",
+         request->result_cb, result_request_retrieve_conf,
result_request_send_conf, result_request_notify_resp);
+
        if (request->result_cb == NULL || request->result_cb(request)
== TRUE)
                mms_request_destroy(request);
        else {
@@ -2378,25 +2395,37 @@ void mms_service_push_notify(struct mms_service
*service,
                return;
        }
 
+       DBG("about to push notify");
+
        if (mms_push_notify(data, len, &nread) == FALSE)
                goto out;
 
+       DBG("did push notify; about to store");
+
        uuid = mms_store(service->identity, data + nread, len - nread);
        if (uuid == NULL)
                goto out;
 
+       DBG("did store; about to decode");
+
        if (mms_message_decode(data + nread, len - nread, msg) ==
FALSE)
                goto error;
 
+       DBG("did decode message");
+
        if (msg->type == MMS_MESSAGE_TYPE_DELIVERY_IND) {
                msg->uuid = g_strdup(uuid);
 
                dump_delivery_ind(msg);
 
+               DBG("about to store_meta_open");
+
                meta = mms_store_meta_open(service->identity, uuid);
                if (meta == NULL)
                        goto error;
 
+               DBG("did store_meta_open");
+
                g_key_file_set_string(meta, "info", "state",
"notification");
 
                mms_store_meta_close(service->identity, uuid, meta,
TRUE);
@@ -2404,17 +2433,25 @@ void mms_service_push_notify(struct mms_service
*service,
                return;
        }
 
+       DBG("is type NI?");
+
        if (msg->type != MMS_MESSAGE_TYPE_NOTIFICATION_IND)
                goto error;
 
+       DBG("type is NI");
+
        msg->uuid = g_strdup(uuid);
 
        dump_notification_ind(msg);
 
+       DBG("about to store_meta_open 2");
+
        meta = mms_store_meta_open(service->identity, uuid);
        if (meta == NULL)
                goto error;
 
+       DBG("did store_meta_open 2");
+
        g_key_file_set_boolean(meta, "info", "read", FALSE);
 
        g_key_file_set_string(meta, "info", "state", "notification");
@@ -2427,6 +2464,8 @@ void mms_service_push_notify(struct mms_service
*service,
        if (request == NULL)
                goto out;
 
+       DBG("did create_request");
+
        g_queue_push_tail(service->request_queue, request);
 
        activate_bearer(service);
@@ -2442,12 +2481,16 @@ out:
        mms_error("Failed to handle incoming notification");
 }
 
+void debug_print(const char* s, void* data) {
+       printf("%s\n", s);
+}
+
 void mms_service_bearer_notify(struct mms_service *service, mms_bool_t
active,
                                const char *interface, const char
*proxy)
 {
        int ifindex;
 
-       DBG("service %p active %d", service, active);
+       DBG("service=%p active=%d iface=%s proxy=%s", service, active,
interface, proxy);
 
        if (service == NULL)
                return;
@@ -2463,6 +2506,7 @@ void mms_service_bearer_notify(struct mms_service
*service, mms_bool_t active,
        if (active == FALSE)
                goto interface_down;
 
+
        DBG("interface %s proxy %s", interface, proxy);
 
        if (service->web != NULL) {
@@ -2481,6 +2525,8 @@ void mms_service_bearer_notify(struct mms_service
*service, mms_bool_t active,
        if (service->web == NULL)
                return;
 
+       g_web_set_debug(service->web, (GWebDebugFunc)debug_print,
NULL);
+
        /* Sometimes no proxy is reported as string instead of NULL */
        if (g_strcmp0(proxy, "") != 0)
                g_web_set_proxy(service->web, proxy);
diff --git a/test/send-message b/test/send-message
index 558fdaa..8477e79 100755
--- a/test/send-message
+++ b/test/send-message
@@ -5,23 +5,23 @@ import dbus
 import csv
 
 if (len(sys.argv) < 4):
-       print "Usage: %s"\
+       print("Usage: {}"\
                " <recipient>,..."\
                " <smil-file-path>"\
                " <<content-id>,<content-type>,<file-path>>,..."\
-               % (sys.argv[0])
-       print "Sample(Related): %s"\
+               .format(sys.argv[0]))
+       print("Sample(Related): {}"\
                " \"+33611111111,+33622222222\""\
                " \"smil.txt\""\
                " \"cid-1,text/plain,text.txt\""\
                " \"cid-2,image/jpeg,image.jpg\""\
-               % (sys.argv[0])
-       print "Sample(Mixed): %s"\
+               .format(sys.argv[0]))
+       print("Sample(Mixed): {}"\
                " \"+33611111111,+33622222222\""\
                " \"\""\
                " \"cid-1,text/plain,text.txt\""\
                " \"cid-2,image/jpeg,image.jpg\""\
-               % (sys.argv[0])
+               .format(sys.argv[0]))
        sys.exit(1)
 
 bus = dbus.SessionBus()
@@ -38,23 +38,23 @@ service =
dbus.Interface(bus.get_object('org.ofono.mms', path),
 recipients = dbus.Array([],signature=dbus.Signature('s'))
 reader = csv.reader([sys.argv[1]])
 for r in reader:
-       print "Recipient list: %s" % r
+       print("Recipient list: {}".format(r))
        for i in r:
                recipients.append(dbus.String(i))
 
 
 if sys.argv[2] == "":
-       print "Send MMS as Mixed"
+       print("Send MMS as Mixed")
        smil = ""
 else:
-       print "Send MMS as Related"
-       print "Smil path: %s" % (sys.argv[2])
+       print("Send MMS as Related")
+       print("Smil path: {}".format(sys.argv[2]))
        file = open(sys.argv[2],"r")
        smil = dbus.String(file.read())
 
 attachments = dbus.Array([],signature=dbus.Signature('(sss)'))
 for a in sys.argv[3:]:
-       print "Attachment: (%s)" % a
+       print("Attachment: ({})".format(a))
        reader = csv.reader([a])
        for r in reader:
                attachments.append(dbus.Struct((dbus.String(r[0]),
@@ -64,4 +64,4 @@ for a in sys.argv[3:]:
 
 path = service.SendMessage(recipients, smil, attachments)
 
-print path
+print(path)
-- 
2.30.0


